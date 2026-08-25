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
# Writes vignettes/<slug>.Rmd and vignettes/images/<slug>/NN_<chunk>.png, then
# prints a report. Register the result in _pkgdown.yml under BOTH articles: and
# navbar: -- missing the second fails the build.

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
  block <- gsub("<[^>]+>", "", block)          # tags, incl. per-token <span>s
  block <- gsub("&quot;", '"', block, fixed = TRUE)
  block <- gsub("&#39;",  "'", block, fixed = TRUE)
  block <- gsub("&lt;",   "<", block, fixed = TRUE)
  block <- gsub("&gt;",   ">", block, fixed = TRUE)
  block <- gsub("&amp;",  "&", block, fixed = TRUE)   # last: & is the escape char
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

# ---- 4. write the PNGs -------------------------------------------------------
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

# ---- 5. rebuild the Rmd ------------------------------------------------------
yaml_end <- if (src[[1]] == "---") grep("^---\\s*$", src)[[2]] else 0L
body <- src[seq(yaml_end + 1L, length(src))]
head_src <- if (yaml_end > 0L) src[seq_len(yaml_end)] else character()

title <- sub('^title:\\s*"?(.*?)"?\\s*$', "\\1", grep("^title:", head_src, value = TRUE)[1])
if (is.na(title)) title <- slug

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
prev <- 1L
for (ci in seq_along(chunks)) {
  ch <- chunks[[ci]]
  out <- c(out, body_slice <- src[seq(prev, ch$open - 1L)])

  hdr <- ch$header
  hdr <- gsub("\\s*,?\\s*eval\\s*=\\s*(TRUE|FALSE|T|F)", "", hdr)
  hdr <- sub("\\s+$", "", hdr)
  hdr <- if (grepl("[^,[:space:]]", hdr)) paste0(hdr, ", eval = FALSE") else " eval = FALSE"
  out <- c(out, sprintf("```{r%s}", hdr), ch$code, "```")

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
out <- c(out, src[seq(prev, length(src))])
out <- out[seq(yaml_end + 1L, length(out))]

header <- c(
  "---",
  sprintf('title: "%s"', title),
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

# ---- 6. report ---------------------------------------------------------------
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
if (length(params_chunk)) cat("  params:    surfaced as a visible `paths` chunk\n")
cat("\n  Next: register in _pkgdown.yml under BOTH articles: and navbar:\n")
cat(sprintf("%s\n", strrep("-", 60)))
