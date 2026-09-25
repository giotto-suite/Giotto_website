#!/usr/bin/env Rscript
# Validate the website's structure without building it.
#
#   Rscript pkgdown/check-site.R              # errors and warnings
#   Rscript pkgdown/check-site.R --quiet      # errors only
#   Rscript pkgdown/check-site.R --pkg ../Giotto   # also check reference: topics
#
# Run from the repository root. Exits 1 if any ERROR is found, 0 otherwise.
#
# WHY THIS EXISTS
# The mistakes people actually make when adding a tutorial -- forgetting to
# register it, pointing a navbar entry at a file that isn't there, renaming an
# `articles:` section and orphaning the navbar links into it, referencing a
# figure that was never committed -- are all decidable by reading text. But the
# only thing that reports them today is a build: 5-10 minutes for the dev site,
# 40-70 for release, 20-30 locally. Worse, `preview-sites.R --quick` skips
# articles entirely, so the fast local check cannot see them at all.
#
# Everything here is plain text and YAML parsing. It reads `_pkgdown.yml` but
# never writes it: that file is ~1000 hand-commented lines whose section
# anchors are load-bearing, and a YAML round-trip would strip the comments.
#
# ERROR vs WARNING
# ERROR   = pkgdown fails, or the published site gets a dead link.
# WARNING = worth a look, legitimate in the tree as it stands.
#
# The warnings are deliberately not errors:
#  * A tutorial with no navbar entry is fine -- 43 of them are reached only
#    through `articles/index.html`, which is the documented design for the long
#    tail. Making this an error would demand ~43 navbar entries nobody wants.
#  * A chunk that evaluates is fine when it is self-contained presentation code
#    (`kableExtra::kable()` over an inline data.frame, `sprintf()` building
#    image tiles). What must never evaluate is code touching Giotto data or
#    files on disk, and that distinction is not mechanically decidable -- so
#    this reports and leaves the judgement to a person.

args  <- commandArgs(trailingOnly = TRUE)
quiet <- "--quiet" %in% args

pkg_arg <- which(args == "--pkg")
pkg_src <- if (length(pkg_arg) && length(args) > pkg_arg[[1]]) {
  args[[pkg_arg[[1]] + 1L]]
} else {
  "../Giotto"
}

if (!file.exists("_pkgdown.yml")) {
  stop("Run this from the repository root (no _pkgdown.yml here).", call. = FALSE)
}
if (!requireNamespace("yaml", quietly = TRUE)) {
  stop("yaml is not installed: install.packages('yaml')", call. = FALSE)
}

errors <- character()
warns  <- character()
err  <- function(...) errors <<- c(errors, sprintf(...))
warn <- function(...) warns  <<- c(warns,  sprintf(...))

cfg <- yaml::read_yaml("_pkgdown.yml")

# ---- inventory --------------------------------------------------------------
# Two vignettes use a lowercase .rmd extension, so match case-insensitively or
# they are silently skipped by every check below.
vig_files <- list.files("vignettes", pattern = "\\.[Rr]md$")
vig_names <- sub("\\.[Rr]md$", "", vig_files)
names(vig_files) <- vig_names

# ---- articles: registration -------------------------------------------------
# This is the one that hard-fails a build. pkgdown aborts with "Vignettes
# missing from index" for any article not listed under `articles:`.
sections <- cfg$articles
listed   <- character()
anchors  <- character()

for (sec in sections) {
  title <- if (is.null(sec$title)) "<untitled>" else sec$title
  # `desc:` carries an <span id="..."> that the navbar deep-links into. It is
  # the anchor, not decoration -- renaming a section silently breaks the links.
  if (!is.null(sec$desc)) {
    a <- regmatches(sec$desc, gregexpr('<span id="[^"]+"', sec$desc))[[1]]
    anchors <- c(anchors, sub('.*id="', "", sub('"$', "", a)))
  }
  for (item in sec$contents) {
    # pkgdown allows selector expressions (starts_with(), matches()). None are
    # used here; pass them through rather than reporting them as missing files.
    if (grepl("[()]", item)) {
      warn("articles: section '%s' uses the selector `%s`; not checked", title, item)
      next
    }
    if (item %in% listed) {
      err("articles: '%s' is listed twice (second time under '%s')", item, title)
    }
    listed <- c(listed, item)
    if (!item %in% vig_names) {
      err("articles: section '%s' lists '%s', but vignettes/%s.Rmd does not exist",
          title, item, item)
    }
  }
}

for (v in setdiff(vig_names, listed)) {
  err(paste0("vignettes/%s is not registered under `articles:` in _pkgdown.yml.\n",
             "         pkgdown will abort with \"Vignettes missing from index\"."),
      vig_files[[v]])
}

# ---- navbar links -----------------------------------------------------------
# Collect every href anywhere under navbar:, at any nesting depth.
collect_hrefs <- function(x) {
  if (!is.list(x)) return(character())
  h <- if (!is.null(x$href) && is.character(x$href)) x$href else character()
  c(h, unlist(lapply(x, collect_hrefs), use.names = FALSE))
}
hrefs <- unique(collect_hrefs(cfg$navbar))

article_hrefs <- grep("^articles/", hrefs, value = TRUE)
linked <- character()

for (h in article_hrefs) {
  target <- sub("#.*$", "", h)
  anchor <- if (grepl("#", h)) sub("^.*#", "", h) else NA_character_
  slug   <- sub("^articles/", "", sub("\\.html$", "", target))

  if (slug == "index") {
    # The articles index itself. Its fragments are the section anchors.
    if (!is.na(anchor) && !anchor %in% anchors) {
      err(paste0("navbar: links to `%s`, but no `articles:` section has\n",
                 "         <span id=\"%s\"> in its desc: -- the link will land at the",
                 " top of the page.\n",
                 "         A section was probably renamed without updating the href."),
          h, anchor)
    }
  } else if (!slug %in% vig_names) {
    err("navbar: links to `%s`, but vignettes/%s.Rmd does not exist", h, slug)
  } else {
    linked <- c(linked, slug)
  }
}

# ---- per-vignette checks ----------------------------------------------------
# Split a tutorial into its R chunks and its prose, tracking fence state as we
# go. The state machine matters: plain ``` example blocks hold deliberately fake
# paths (contributing_tutorials.Rmd documents `images/TUTORIAL_FOLDER/...`), and
# a naive grep reports those as missing figures.
split_rmd <- function(lines) {
  chunks <- list()
  prose  <- character()
  state  <- "prose"
  hdr    <- ""
  start  <- 0L
  body   <- character()

  for (i in seq_along(lines)) {
    line <- lines[[i]]

    if (identical(state, "other")) {
      if (grepl("^\\s*```\\s*$", line)) state <- "prose"
      next
    }

    if (identical(state, "chunk")) {
      if (grepl("^\\s*```\\s*$", line)) {
        chunks[[length(chunks) + 1L]] <- list(hdr = hdr, body = body, line = start)
        state <- "prose"
      } else {
        body <- c(body, line)
      }
      next
    }

    if (grepl("^\\s*```\\{[rR]", line)) {
      state <- "chunk"
      hdr   <- line
      start <- i
      body  <- character()
    } else if (grepl("^\\s*```", line)) {
      state <- "other"
    } else {
      prose <- c(prose, line)
    }
  }

  list(chunks = chunks, prose = prose)
}

for (v in vig_names) {
  L <- readLines(file.path("vignettes", vig_files[[v]]), warn = FALSE)

  # `pkgdown: as_is: true` keeps the tutorial's own HTML output (number_sections,
  # toc) instead of re-rendering it into the pkgdown template.
  head_end <- min(40L, length(L))
  if (!any(grepl("^\\s*as_is:\\s*true\\s*$", L[seq_len(head_end)]))) {
    err("vignettes/%s: YAML header is missing `pkgdown: as_is: true`",
        vig_files[[v]])
  }

  parts <- split_rmd(L)

  # A setup chunk may switch every chunk off at once, instead of per chunk.
  global_eval_off <- any(grepl(
    "opts_chunk\\$set\\([^)]*eval\\s*=\\s*(FALSE|F)\\b", L))

  figs <- character()

  for (ch in parts$chunks) {
    figs <- c(figs, unlist(regmatches(
      ch$body, gregexpr('include_graphics\\(\\s*"[^"]+"', ch$body))))

    code <- trimws(ch$body)
    code <- code[nzchar(code) & !grepl("^#", code)]
    if (!length(code)) next
    if (global_eval_off || grepl("eval\\s*=\\s*(FALSE|F)\\b", ch$hdr)) next
    # Figure and library-only chunks are meant to run.
    if (all(grepl(paste0("^(knitr::)?include_graphics|^library\\(",
                         "|^(knitr::)?opts_chunk\\$set"), code))) next
    warn(paste0("vignettes/%s:%d evaluates (no eval=FALSE): %s\n",
                "         Fine if it is self-contained presentation code;",
                " a build failure\n         if it touches Giotto data."),
         vig_files[[v]], ch$line, substr(paste(code, collapse = " "), 1, 60))
  }

  figs <- sub('.*?"([^"]+)".*', "\\1", figs)
  md <- unlist(regmatches(
    parts$prose, gregexpr('!\\[[^]]*\\]\\([^)]+\\)', parts$prose)))
  figs <- c(figs, sub('!\\[[^]]*\\]\\(([^)]+)\\)', "\\1", md))

  for (f in unique(figs[grepl("^images/", figs)])) {
    if (!file.exists(file.path("vignettes", f))) {
      err("vignettes/%s references vignettes/%s, which does not exist",
          vig_files[[v]], f)
    }
  }
}

# ---- dataset tags -----------------------------------------------------------
# The dataset browser is generated from each tutorial's `tags:` header. Reuse
# the generator's own parsing and validation rather than a second copy of the
# rules, then fail if the committed page no longer matches what it would write:
# a stale page silently hides a new tutorial, or links a renamed one.
ds_env <- new.env()
sys.source("pkgdown/build-dataset-index.R", envir = ds_env)
ds <- ds_env$collect_datasets()
for (p in ds_env$validate_datasets(ds)) err("%s", p)
if (!identical(ds_env$render_datasets(ds),
               if (file.exists(ds_env$OUT)) readLines(ds_env$OUT, warn = FALSE))) {
  err(paste0("%s is out of date with the tutorials' `tags:` headers.\n",
             "         Run: Rscript pkgdown/build-dataset-index.R"), ds_env$OUT)
}

# ---- reference: index -------------------------------------------------------
# The other hard failure. pkgdown aborts with "N topics missing from index" for
# any documented topic that is neither listed under `reference:` nor marked
# `@keywords internal`. There is no third option and no warning-only mode: the
# build produces nothing.
#
# This needs the package being documented, which does not live here -- so it is
# skipped when no clone is around. CI's check job sparse-checks-out just the
# package's DESCRIPTION and man/ for it. Either way it turns an hour-deep build
# failure into a second.
#
# Only the documented package's own topics are checked. `reference:` also lists
# GiottoClass::/GiottoVisuals::/... topics, which pkgdown resolves from the
# installed packages; those are not this package's to index.
if (!file.exists(file.path(pkg_src, "DESCRIPTION"))) {
  if (!quiet) {
    message(sprintf(paste0(
      "\nnote: no package source at '%s', so `reference:` topics were not",
      " checked.\n      Pass --pkg <path> to include them."), pkg_src))
  }
} else {
  indexed <- unlist(lapply(cfg$reference, function(sec) sec$contents))
  indexed <- indexed[!grepl("::", indexed)]        # cross-package entries
  indexed <- sub("\\(\\)$", "", indexed)             # a few carry trailing ()

  rds <- list.files(file.path(pkg_src, "man"), pattern = "\\.[Rr]d$",
                    full.names = TRUE)
  missing <- character()
  for (rd in rds) {
    txt <- readLines(rd, warn = FALSE)
    if (any(grepl("^\\s*\\\\keyword\\{internal\\}", txt))) next
    al <- unlist(regmatches(txt, gregexpr("\\\\alias\\{[^}]+\\}", txt)))
    al <- sub("\\\\alias\\{", "", sub("\\}$", "", al))
    # A topic counts as indexed if any one of its aliases is listed.
    if (length(al) && !any(al %in% indexed)) missing <- c(missing, al[[1]])
  }
  if (length(missing)) {
    err(paste0("%d documented topic%s missing from `reference:` in _pkgdown.yml:",
               " %s.\n",
               "         pkgdown will abort with \"N topics missing from index\".",
               " Either add\n",
               "         them under `reference:` or mark them @keywords internal",
               " in %s."),
        length(missing), if (length(missing) == 1) "" else "s",
        paste(sort(missing), collapse = ", "), pkg_src)
  }
}

# ---- warnings ---------------------------------------------------------------
no_nav <- setdiff(vig_names, linked)
if (length(no_nav)) {
  warn(paste0("%d tutorials have no navbar entry, so they are reachable only",
              " through\n         articles/index.html. That is the documented",
              " design for the long tail,\n         not a problem: %s%s"),
       length(no_nav), paste(utils::head(no_nav, 3), collapse = ", "),
       if (length(no_nav) > 3) ", ..." else "")
}
for (a in setdiff(anchors, sub("^.*#", "", grep("#", article_hrefs, value = TRUE)))) {
  warn("articles: section anchor '%s' exists but nothing deep-links to it", a)
}

# ---- report -----------------------------------------------------------------
if (length(warns) && !quiet) {
  message(sprintf("\n%d WARNING%s", length(warns), if (length(warns) == 1) "" else "S"))
  for (w in warns) message("  * ", w)
}
if (length(errors)) {
  message(sprintf("\n%d ERROR%s", length(errors), if (length(errors) == 1) "" else "S"))
  for (e in errors) message("  x ", e)
  message(sprintf("\nchecked %d vignettes, %d navbar article links -- FAILED",
                  length(vig_names), length(article_hrefs)))
  quit(status = 1L)
}
message(sprintf("\nchecked %d vignettes, %d navbar article links -- OK",
                length(vig_names), length(article_hrefs)))
