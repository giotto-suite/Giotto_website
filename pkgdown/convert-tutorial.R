#!/usr/bin/env Rscript
# Convert an authored, fully-evaluated .Rmd + its rendered .html into a
# website tutorial: figures extracted to disk, every chunk switched off.
#
# WHY
# Website tutorials never evaluate (see vignettes/contributing_tutorials.Rmd).
# Figures are committed as PNGs and pulled in with knitr::include_graphics().
# That keeps builds fast and deterministic, and it is why a tutorial can be
# published for a package that is not installable in CI -- nothing runs.
#
# Authored tutorials are the opposite: every chunk evaluates and every figure
# is base64-embedded in a rendered HTML file that can run to tens of MB. This
# script bridges the two, matching each embedded figure back to the chunk that
# produced it by comparing the source knitr echoed above it.
#
# USAGE
#   Rscript pkgdown/convert-tutorial.R <source.Rmd> <rendered.html> <slug>
#
# A chunk's printed output is carried across too, as a plain fenced block below
# the code, matching how the tutorials that have it are written by hand today.
# A chunk that should run noisily but publish quietly says so in its header:
#
#   ```{r save-annotated, keep_output = FALSE}
#
# knitr ignores the option, so the render is unchanged and you still see the
# messages while working. The alternative is to suppress at render time with
# message = FALSE or results = 'hide', which keeps the output out of the HTML
# altogether -- cheaper to reason about, but you lose it while developing and
# changing your mind costs another render.
#
# Writes vignettes/<slug>.Rmd and vignettes/images/<slug>/NN_<chunk>.png, then
# prints a report. Register the result in _pkgdown.yml under articles: -- that
# one is required, and pkgdown fails the build without it. A navbar: entry is
# optional and only affects discoverability. Then run pkgdown/check-site.R.

suppressPackageStartupMessages({
  library(magick)
})

MAX_WIDTH <- 1100L   # site content column renders at ~880px; 1100 covers retina

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3L) {
  stop("usage: convert-tutorial.R <source.Rmd> <rendered.html> <slug>", call. = FALSE)
}
rmd_in <- args[[1]]; html_in <- args[[2]]; slug <- args[[3]]
for (f in c(rmd_in, html_in)) if (!file.exists(f)) stop("no such file: ", f, call. = FALSE)

# A render older than its source is the one failure that looks like success:
# figures still extract, they just belong to code the author has since changed.
# Refuse rather than publish figures that do not match the printed code.
if (file.mtime(rmd_in) > file.mtime(html_in)) {
  stop(sprintf(paste0(
    "%s is newer than %s (by %.0f h).\n",
    "  The render is stale, so its figures do not match the current code.\n",
    "  Re-knit the source, then run this again."),
    basename(rmd_in), basename(html_in),
    as.numeric(difftime(file.mtime(rmd_in), file.mtime(html_in), units = "hours"))),
    call. = FALSE)
}

img_dir <- file.path("vignettes", "images", slug)
rmd_out <- file.path("vignettes", paste0(slug, ".Rmd"))

# ---- 1. split the source into chunks ----------------------------------------
src <- readLines(rmd_in, warn = FALSE)

open_re  <- "^```\\{r(.*)\\}\\s*$"
opens  <- grep(open_re, src)
fences <- grep("^```\\s*$", src)

chunks <- lapply(opens, function(o) {
  close <- fences[fences > o]
  if (!length(close)) stop("unterminated chunk at line ", o, call. = FALSE)
  close <- close[[1]]
  hdr <- sub(open_re, "\\1", src[[o]])
  lbl <- trimws(strsplit(hdr, ",")[[1]][[1]])
  if (!nzchar(lbl) || grepl("=", lbl)) lbl <- ""
  list(open = o, close = close, header = hdr, label = lbl,
       code = src[seq(o + 1L, close - 1L)])
})

norm <- function(x) gsub("\\s+", " ", trimws(paste(x, collapse = " ")))

# seq(a, b) counts DOWN when a > b, so an empty range yields two wrong indices
# instead of none: src[length(src) + 1L] is NA and the line before it repeats.
# That is where the trailing "NA" and unclosed fence at the end of several
# published tutorials came from.
span <- function(from, to) if (from > to) integer() else seq(from, to)

untag <- function(x) {
  x <- gsub("<[^>]+>", "", x)                  # tags, incl. per-token <span>s
  x <- gsub("&quot;", '"', x, fixed = TRUE)
  x <- gsub("&#39;",  "'", x, fixed = TRUE)
  x <- gsub("&lt;",   "<", x, fixed = TRUE)
  x <- gsub("&gt;",   ">", x, fixed = TRUE)
  gsub("&amp;",  "&", x, fixed = TRUE)         # last: & is the escape char
}

# ---- 2. pull the embedded figures out of the rendered HTML ------------------
# Only data:image/png;base64 -- a plain "<img" search also hits image tags
# constructed inside the bundled jQuery, which are not figures.
html <- paste(readLines(html_in, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

img_re <- '<img[^>]*src="data:image/png;base64,([A-Za-z0-9+/=\\s]+)"[^>]*>'
m <- gregexpr(img_re, html, perl = TRUE)[[1]]
if (identical(as.integer(m), -1L)) stop("no base64 PNG figures found in ", html_in, call. = FALSE)
starts <- as.integer(m); lens <- attr(m, "match.length")

payload_of <- function(tag) {
  p <- sub('.*src="data:image/png;base64,', "", tag)
  gsub("[^A-Za-z0-9+/=]", "", sub('".*$', "", p))
}

# The code knitr echoed immediately above a figure identifies the chunk that
# produced it. Two markups appear across the corpus depending on the `highlight:`
# the author chose -- plain `<pre class="r"><code>` and pandoc's tokenised
# `<pre class="sourceCode r">`. Take the last <pre> of either kind and strip it
# back to text.
code_above <- function(pos) {
  pre <- substr(html, 1L, pos)
  # source blocks only. Output blocks are also <pre>, and with collapse = TRUE
  # they are interleaved between a chunk's figures.
  hits <- gregexpr('<pre[^>]*class="[^"]*\\br\\b[^"]*"[^>]*>', pre, perl = TRUE)[[1]]
  if (identical(as.integer(hits), -1L)) return("")
  last <- max(as.integer(hits))
  from <- last + attr(hits, "match.length")[[which.max(as.integer(hits))]]
  block <- substr(pre, from, nchar(pre))
  block <- sub("</pre>.*$", "", block)
  block <- untag(block)
  # collapse = TRUE folds printed output into the source block; drop it so the
  # comparison sees only what the author wrote.
  keep <- grep("^\\s*(#>|##)", strsplit(block, "\n", fixed = TRUE)[[1]],
               invert = TRUE, value = TRUE)
  norm(keep)
}

figs <- lapply(seq_along(starts), function(i) {
  tag <- substr(html, starts[[i]], starts[[i]] + lens[[i]] - 1L)
  list(payload = payload_of(tag), above = code_above(starts[[i]]))
})

# ---- 3. match each figure to its chunk --------------------------------------
# knitr echoes chunk source verbatim, so the tail of the code block above a
# figure is the tail of that chunk. Compare on the last 60 normalised chars:
# enough to be unique, short enough to survive echo trimming.
tailkey <- function(x, n = 60L) substr(x, max(1L, nchar(x) - n + 1L), nchar(x))

owner <- integer(length(figs))
for (i in seq_along(figs)) {
  above <- figs[[i]]$above
  codes <- vapply(chunks, function(ch) norm(ch$code), "")
  hit <- which(codes == above)                       # knitr echoes verbatim
  if (!length(hit)) {                                # options can trim the echo
    k <- tailkey(above)
    hit <- which(nzchar(k) & vapply(codes, function(cd) grepl(k, cd, fixed = TRUE), logical(1)))
  }
  owner[[i]] <- if (length(hit)) hit[[length(hit)]] else NA_integer_
}

# ---- 4. pull printed output out of the rendered HTML -------------------------
# knitr gives a chunk's output its own <pre> with no class, every line prefixed
# by `comment` (`##` by default). Source blocks carry class="r" and markdown's
# own fences carry a language class, so an unclassed <pre> whose every line is
# prefixed is output and nothing else. A tutorial that overrides `comment` falls
# outside that test and keeps the old behaviour -- output dropped rather than
# guessed at.
pre_m   <- gregexpr("(?s)<pre[^>]*>.*?</pre>", html, perl = TRUE)[[1]]
pre_txt <- if (identical(as.integer(pre_m), -1L)) character() else
  substring(html, as.integer(pre_m),
            as.integer(pre_m) + attr(pre_m, "match.length") - 1L)

is_source <- grepl('^<pre[^>]*class="[^"]*\\br\\b[^"]*"', pre_txt, perl = TRUE)
is_plain  <- grepl("^<pre>", pre_txt)

pre_lines <- function(x) {
  strsplit(untag(sub("(?s)^<pre[^>]*>(.*)</pre>$", "\\1", x, perl = TRUE)),
           "\n", fixed = TRUE)[[1]]
}

codes <- vapply(chunks, function(ch) norm(ch$code), "")
chunk_of <- function(x) {
  code <- norm(grep("^\\s*(#>|##)", pre_lines(x), invert = TRUE, value = TRUE))
  hit <- which(codes == code)
  if (!length(hit)) {
    k <- tailkey(code)
    hit <- which(nzchar(k) & vapply(codes, function(cd) grepl(k, cd, fixed = TRUE), logical(1)))
  }
  if (length(hit)) hit[[length(hit)]] else NA_integer_
}

outputs <- vector("list", length(chunks))
orphans <- 0L            # output whose chunk could not be identified
cur <- NA_integer_
for (i in seq_along(pre_txt)) {
  if (is_source[[i]]) { cur <- chunk_of(pre_txt[[i]]); next }
  if (!is_plain[[i]]) { cur <- NA_integer_; next }   # a markdown fence, e.g. class="sh"
  ln  <- pre_lines(pre_txt[[i]])
  txt <- ln[nzchar(trimws(ln))]
  if (!length(txt) || !all(grepl("^\\s*(##|#>)", txt))) { cur <- NA_integer_; next }
  # Classify the block before deciding what to do with it, so output that
  # cannot be placed is counted rather than passed over in silence.
  if (is.na(cur)) { orphans <- orphans + 1L; next }
  outputs[[cur]] <- c(outputs[[cur]], sub("^(\\s*)(##|#>) ?", "\\1", ln))
}

# ---- 5. write the PNGs -------------------------------------------------------
dir.create(img_dir, recursive = TRUE, showWarnings = FALSE)
unlink(list.files(img_dir, full.names = TRUE))

paths <- character(length(figs))
for (i in seq_along(figs)) {
  lbl <- if (is.na(owner[[i]])) "figure" else chunks[[owner[[i]]]]$label
  if (!nzchar(lbl)) lbl <- "figure"
  lbl <- gsub("[^A-Za-z0-9]+", "-", lbl)
  f <- file.path(img_dir, sprintf("%02d_%s.png", i, lbl))
  img <- image_read(base64enc::base64decode(figs[[i]]$payload))
  w <- image_info(img)$width
  if (isTRUE(w > MAX_WIDTH)) img <- image_resize(img, paste0(MAX_WIDTH, "x"))
  image_write(image_strip(img), f, format = "png")
  paths[[i]] <- f
}

# ---- 6. rebuild the Rmd ------------------------------------------------------
yaml_end <- if (src[[1]] == "---") grep("^---\\s*$", src)[[2]] else 0L
body <- src[seq(yaml_end + 1L, length(src))]
head_src <- if (yaml_end > 0L) src[seq_len(yaml_end)] else character()

title <- sub('^title:\\s*"?(.*?)"?\\s*$', "\\1", grep("^title:", head_src, value = TRUE)[1])
if (is.na(title)) title <- slug

# tags: drives the dataset browser's filters, is written by hand, and there is
# nothing here to regenerate it from. Carry the block across verbatim or the
# tutorial silently drops out of the browser.
tags_block <- character()
tstart <- grep("^tags:\\s*$", head_src)
if (length(tstart)) {
  tlines <- head_src[span(tstart[[1]] + 1L, length(head_src))]
  ends   <- which(!grepl("^\\s+\\S", tlines))
  n_keep <- if (length(ends)) ends[[1]] - 1L else length(tlines)
  if (n_keep > 0L) tags_block <- c("tags:", tlines[seq_len(n_keep)])
}

# params: exists only to feed evaluated code. Nothing evaluates here, so surface
# the values as a visible chunk instead of silently dropping them -- the reader
# still needs to know what the paths mean.
params_chunk <- character()
pstart <- grep("^params:\\s*$", head_src)
if (length(pstart)) {
  plines <- head_src[seq(pstart[[1]] + 1L, length(head_src))]
  plines <- plines[grepl("^\\s+\\S", plines)]
  plines <- sub("^\\s+", "", plines)
  if (length(plines)) {
    kv <- vapply(plines, function(l) {
      k <- trimws(sub(":.*$", "", l)); v <- trimws(sub("^[^:]+:\\s*", "", l))
      sprintf('    %s = %s', k, if (grepl('^".*"$', v)) v else sprintf('"%s"', v))
    }, "")
    params_chunk <- c("```{r paths, eval = FALSE}",
                      "params <- list(", paste(kv, collapse = ",\n"), ")", "```", "")
  }
}

# every chunk off, and an include_graphics chunk after each producer
out <- character()
kept_own <- 0L
prev <- 1L
for (ci in seq_along(chunks)) {
  ch <- chunks[[ci]]
  out <- c(out, src[span(prev, ch$open - 1L)])

  hdr <- ch$header
  # keep_output is ours, not knitr's: strip it so the published chunk does not
  # carry an option no reader can look up.
  hdr <- gsub("\\s*,?\\s*keep_output\\s*=\\s*(TRUE|FALSE|T|F)", "", hdr)
  hdr <- gsub("\\s*,?\\s*eval\\s*=\\s*(TRUE|FALSE|T|F)", "", hdr)
  hdr <- sub("\\s+$", "", hdr)
  hdr <- if (grepl("[^,[:space:]]", hdr)) paste0(hdr, ", eval = FALSE") else " eval = FALSE"
  out <- c(out, sprintf("```{r%s}", hdr), ch$code, "```")

  # output before figures: a chunk that prints and then plots is the common
  # order, and keeping one include_graphics block per chunk keeps the naming
  # predictable.
  # An author who pasted output into the source already has it, and the
  # following prose carries it through, so adding ours would print it twice.
  nxt <- ch$close + 1L
  while (nxt <= length(src) && !nzchar(trimws(src[[nxt]]))) nxt <- nxt + 1L
  has_own <- nxt <= length(src) && grepl("^\\s*```\\s*$", src[[nxt]])

  keep_out <- !grepl("keep_output\\s*=\\s*(FALSE|F)\\b", ch$header)
  if (keep_out && !has_own && length(outputs[[ci]])) {
      out <- c(out, "", "```", outputs[[ci]], "```")
  }
  if (has_own && length(outputs[[ci]])) kept_own <- kept_own + 1L

  mine <- which(owner == ci)
  if (length(mine)) {
    lbl <- if (nzchar(ch$label)) ch$label else sprintf("chunk%02d", ci)
    out <- c(out, "",
      sprintf("```{r %s-fig, echo = FALSE, out.width = \"100%%\"}", lbl),
      sprintf('knitr::include_graphics("%s")',
              paste0("images/", slug, "/", basename(paths[mine]))),
      "```")
  }
  prev <- ch$close + 1L
}
out <- c(out, src[span(prev, length(src))])
out <- out[seq(yaml_end + 1L, length(out))]

header <- c(
  "---",
  sprintf('title: "%s"', title),
  tags_block,
  "output:",
  "  html_document:",
  "    number_sections: true",
  "    toc: true",
  "pkgdown:",
  "  as_is: true",
  "vignette: >",
  sprintf("  %%\\VignetteIndexEntry{%s}", title),
  "  %\\VignetteEngine{knitr::rmarkdown}",
  "  %\\VignetteEncoding{UTF-8}",
  "---",
  ""
)

dir.create("vignettes", showWarnings = FALSE)
writeLines(c(header, params_chunk, out), rmd_out)

# ---- 7. report ---------------------------------------------------------------
left_on <- sum(grepl("eval\\s*=\\s*TRUE", readLines(rmd_out, warn = FALSE)))
cat(sprintf("\n%s\n", strrep("-", 60)))
cat(sprintf("  source     %s\n", rmd_in))
cat(sprintf("  wrote      %s\n", rmd_out))
cat(sprintf("  figures    %d -> %s/  (%s)\n", length(figs), img_dir,
            format(structure(sum(file.size(paths)), class = "object_size"),
                   units = "auto")))
cat(sprintf("  chunks     %d, all eval = FALSE (%d left TRUE)\n", length(chunks), left_on))
if (anyNA(owner)) {
  cat(sprintf("  UNMATCHED  %d of %d figure(s) could not be traced to a chunk;\n",
              sum(is.na(owner)), length(figs)))
  cat("             they are saved as NN_figure.png and left unplaced.\n")
  if (sum(is.na(owner)) > length(figs) / 2) {
    cat("             Most figures failed to match, which usually means the\n")
    cat("             render predates edits to the source. Re-knit and retry.\n")
  }
}
dropped <- vapply(chunks, function(ch)
    grepl("keep_output\\s*=\\s*(FALSE|F)\\b", ch$header), logical(1))
n_out <- sum(lengths(outputs) > 0L & !dropped)
cat(sprintf("  output     %d of %d chunk(s) kept their printed output\n",
            n_out, length(chunks)))
if (kept_own > 0L) {
  cat(sprintf("  kept       %d chunk(s) already had output in the source\n",
              kept_own))
}
if (orphans > 0L) {
  cat(sprintf("  ORPHANED   %d output block(s) could not be traced to a chunk\n",
              orphans))
  cat("             and were left out. This follows the same matching as the\n")
  cat("             figures, so a stale render is the usual cause.\n")
}
if (any(dropped & lengths(outputs) > 0L)) {
  cat(sprintf("  dropped    %d chunk(s) asked for keep_output = FALSE\n",
              sum(dropped & lengths(outputs) > 0L)))
}
if (length(tags_block)) cat("  tags:      carried across from the source header\n")
if (length(params_chunk)) cat("  params:    surfaced as a visible `paths` chunk\n")

# Restored output is verbatim, so a path a chunk printed now reaches the page.
leaks <- grep("(?<![A-Za-z0-9_.:])/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/",
              unlist(outputs), perl = TRUE, value = TRUE)
if (length(leaks)) {
  cat(sprintf("  PATHS      %d restored line(s) carry an absolute path:\n", length(leaks)))
  for (l in head(leaks, 5L)) cat(sprintf("             %s\n", trimws(substr(l, 1L, 70L))))
  if (length(leaks) > 5L) cat(sprintf("             ... and %d more\n", length(leaks) - 5L))
}
cat("\n  Next: add the slug to a contents: list under articles: in _pkgdown.yml\n")
cat("        (required), optionally a navbar: entry, then pkgdown/check-site.R\n")
cat(sprintf("%s\n", strrep("-", 60)))
