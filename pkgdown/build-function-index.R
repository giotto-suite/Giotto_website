#!/usr/bin/env Rscript
# Generate vignettes/function_index.Rmd -- one page listing every exported
# function across the Giotto ecosystem, each linking to its canonical page.
#
# WHY
# pkgdown builds one site per package, so the five Giotto packages have five
# sites. The main reference index already lists 165 cross-package topics, but
# clicking one leaves the site. This is a *directory*, not a merge: a single
# flat, complete, ctrl-F-able list. It is also a good retrieval target for
# anything reading the docs programmatically.
#
# GENERATED AND COMMITTED, like man/ and roxygen. Re-run it when the API
# changes and commit the result:
#
#   Rscript pkgdown/build-function-index.R
#
# It prints a summary of what changed so a stale checkout is obvious.
#
# Links: topics in Giotto itself are linked relatively, so the dev site points
# at its own pages rather than the released site. Sibling packages are linked
# absolutely to their own pkgdown sites, resolved from each package's published
# pkgdown.yml where reachable, falling back to its DESCRIPTION URL offline.

PKGS <- c("Giotto", "GiottoClass", "GiottoVisuals", "GiottoUtils", "GiottoData")
SELF <- "Giotto"
OUT  <- "vignettes/function_index.Rmd"

`%||%` <- function(a, b) if (is.null(a)) b else a
rd_tag <- function(x) attr(x, "Rd_tag") %||% ""

# ---- resolve each package's canonical reference URL -------------------------
#
# Neither the package metadata nor the published site metadata can be trusted
# on its own. Both went stale after the drieslab -> giotto-suite org move:
#   * GiottoData's DESCRIPTION URL still says drieslab.github.io
#   * GiottoUtils' DESCRIPTION is correct, but its PUBLISHED pkgdown.yml still
#     says drieslab (the site has not been rebuilt since the move)
# drieslab.github.io 404s, and this is already a live bug -- 2 of the 222
# cross-package links on giottosuite.com point there today.
#
# So: gather candidates from every source, then pick the first that actually
# responds. Self-healing, and immune to whichever source is stale.
url_ok <- function(u) {
  con <- tryCatch(url(u, open = "rb"), error = function(e) NULL)
  if (is.null(con)) return(FALSE)
  on.exit(try(close(con), silent = TRUE), add = TRUE)
  isTRUE(tryCatch({ readBin(con, "raw", 1L); TRUE }, error = function(e) FALSE))
}

reference_url <- function(pkg) {
  cand <- character()

  # 1. whatever the installed package declares
  desc_urls <- tryCatch(utils::packageDescription(pkg)$URL, error = function(e) NULL)
  if (!is.null(desc_urls)) {
    d <- trimws(strsplit(desc_urls, ",")[[1]])
    d <- grep("^https?://", d, value = TRUE)
    d <- grep("github\\.com", d, value = TRUE, invert = TRUE)
    cand <- c(cand, paste0(sub("/+$", "", d), "/reference"))
  }

  # 2. whatever each candidate site's own pkgdown.yml declares
  for (u in unique(sub("/reference$", "", cand))) {
    got <- tryCatch(suppressWarnings(readLines(paste0(u, "/pkgdown.yml"), warn = FALSE)),
                    error = function(e) NULL)
    if (!is.null(got)) {
      y <- tryCatch(yaml::yaml.load(paste(got, collapse = "\n")), error = function(e) NULL)
      if (!is.null(y$urls$reference)) cand <- c(cand, y$urls$reference)
    }
  }

  # 3. the canonical org, as a known-good default
  cand <- c(cand, sprintf("https://giotto-suite.github.io/%s/reference", pkg))

  for (u in unique(cand)) if (url_ok(paste0(u, "/index.html"))) return(u)
  NA_character_
}

# ---- topics + titles, excluding internal ------------------------------------
topics_of <- function(pkg) {
  db <- tryCatch(tools::Rd_db(pkg), error = function(e) NULL)
  if (is.null(db) || !length(db)) return(NULL)

  rows <- lapply(names(db), function(f) {
    rd  <- db[[f]]
    tg  <- vapply(rd, rd_tag, "")
    kw  <- vapply(rd[tg == "\\keyword"],
                  function(a) trimws(paste(unlist(a), collapse = "")), "")
    if (any(kw == "internal")) return(NULL)

    ttl <- rd[tg == "\\title"]
    ttl <- if (!length(ttl)) "" else trimws(paste(unlist(ttl[[1]]), collapse = ""))
    ttl <- gsub("\\s+", " ", ttl)

    aliases <- unlist(lapply(rd[tg == "\\alias"],
                             function(a) trimws(paste(unlist(a), collapse = ""))))
    if (!length(aliases)) return(NULL)

    # ONE ROW PER DOCUMENTED TOPIC, not per alias.
    #
    # An Rd file often carries many aliases -- S4 method signatures such as
    # "[<-,affine2d,missing,missing-method" are aliases of the same page. Listing
    # them all produced 1334 rows of mostly noise, and the `<` and `[` in those
    # signatures break markdown table parsing (pandoc silently dropped ~700
    # rows). Listing the topic instead gives a shorter, more useful page that
    # renders correctly.
    #
    # Display name: the alias matching the filename if there is one (the
    # conventional primary name), else the shortest alias, which is almost
    # always the bare function rather than a method signature.
    base  <- sub("\\.Rd$", "", f)
    named <- aliases[aliases == base]
    plain <- aliases[!grepl("[<>,\\[\\]]", aliases)]
    display <- if (length(named)) named[1]
               else if (length(plain)) plain[order(nchar(plain))][1]
               else aliases[order(nchar(aliases))][1]

    others <- setdiff(aliases, display)
    data.frame(topic  = display,
               file   = base,
               title  = ttl,
               n_more = length(others),
               stringsAsFactors = FALSE)
  })
  do.call(rbind, Filter(Negate(is.null), rows))
}

# ---- collect -----------------------------------------------------------------
all_rows <- list()
cat("Resolving reference URLs and reading Rd metadata:\n")
for (p in PKGS) {
  t <- topics_of(p)
  if (is.null(t)) {
    cat(sprintf("  %-14s SKIPPED (not installed)\n", p))
    next
  }
  u <- if (identical(p, SELF)) NA_character_ else reference_url(p)
  t$package <- p
  t$url <- if (identical(p, SELF)) {
    # relative, so the dev site links to its own pages
    paste0("../reference/", t$file, ".html")
  } else if (is.na(u)) {
    NA_character_
  } else {
    paste0(u, "/", t$file, ".html")
  }
  cat(sprintf("  %-14s %4d topics  ->  %s\n", p, nrow(t),
              if (identical(p, SELF)) "(relative, this site)" else u %||% "UNRESOLVED"))
  all_rows[[p]] <- t
}

idx <- do.call(rbind, all_rows)
idx <- idx[!is.na(idx$url), ]
idx <- idx[order(idx$package != SELF, tolower(idx$topic)), ]

# ---- emit --------------------------------------------------------------------
esc <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;",  x, fixed = TRUE)
  x <- gsub(">", "&gt;",  x, fixed = TRUE)
  gsub("|", "\\\\|", x, fixed = TRUE)
}

lines <- c(
  "---",
  'title: "Function index"',
  'output:',
  '  html_document:',
  '    number_sections: false',
  '    toc: true',
  'pkgdown:',
  '  as_is: true',
  'vignette: >',
  '  %\\VignetteIndexEntry{Function index}',
  '  %\\VignetteEngine{knitr::rmarkdown}',
  '  %\\VignetteEncoding{UTF-8}',
  "---",
  "",
  "<!-- GENERATED FILE -- do not edit by hand.",
  "     Regenerate with: Rscript pkgdown/build-function-index.R -->",
  "",
  sprintf("Every exported function across the Giotto ecosystem — **%d entries** across %d packages.",
          nrow(idx), length(unique(idx$package))),
  "Use your browser's find (Ctrl-F / Cmd-F) to jump to a name.",
  "",
  "Functions from `Giotto` link to this site. Functions from the other packages",
  "link to their own documentation site.",
  ""
)

for (p in unique(idx$package)) {
  sub <- idx[idx$package == p, ]
  lines <- c(lines,
    sprintf("## %s <small>(%d)</small>", p, nrow(sub)),
    "",
    "| Function | Description |",
    "|---|---|",
    sprintf("| [`%s`](%s) | %s |", esc(sub$topic), sub$url, esc(sub$title)),
    ""
  )
}

prev_n <- if (file.exists(OUT)) length(readLines(OUT, warn = FALSE)) else 0L
dir.create(dirname(OUT), showWarnings = FALSE, recursive = TRUE)
writeLines(lines, OUT)

cat(sprintf("\nWrote %s\n", OUT))
cat(sprintf("  %d entries, %d packages, %d lines (was %d)\n",
            nrow(idx), length(unique(idx$package)), length(lines), prev_n))
cat("  Commit the result. Re-run when the API changes.\n")
