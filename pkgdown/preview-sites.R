#!/usr/bin/env Rscript
# Build the Giotto Suite website locally and preview it in a browser.
#
#   Rscript pkgdown/preview-sites.R                # release site only (fast)
#   Rscript pkgdown/preview-sites.R --dev          # release + dev at /dev/
#   Rscript pkgdown/preview-sites.R --quick        # skip articles (~1 min)
#   Rscript pkgdown/preview-sites.R --no-serve     # build, don't open a browser
#   Rscript pkgdown/preview-sites.R --pkg ../Giotto  # where the package lives
#
# Run from the repository root.
#
# WHERE THE PACKAGE COMES FROM
# This repository holds website content only -- vignettes, _pkgdown.yml, theme,
# landing page. The package source (R/, man/, NAMESPACE, DESCRIPTION) lives in
# giotto-suite/Giotto and is combined with it at build time, which is exactly
# what CI does. So a preview needs a local clone of the package: `../Giotto` by
# default, or wherever `--pkg` points.
#
# The two are assembled into `.preview-pkgsrc/` (git-ignored) and built there,
# so this mirrors the CI job rather than approximating it.
#
# Notes
#  * Output goes to `docs-preview/` (git-ignored), NOT `docs/`, so a preview can
#    never be mistaken for or overwrite a deploy artifact.
#  * `examples = FALSE` always. Several Rd examples build a Python environment
#    and will shell out to Homebrew/pyenv on a developer machine. Previews never
#    need them.

args     <- commandArgs(trailingOnly = TRUE)
with_dev <- "--dev"        %in% args
quick    <- "--quick"      %in% args
serve    <- !("--no-serve" %in% args)

pkg_arg <- which(args == "--pkg")
pkg_src <- if (length(pkg_arg) && length(args) > pkg_arg[[1]]) {
  args[[pkg_arg[[1]] + 1L]]
} else {
  "../Giotto"
}

if (!file.exists("_pkgdown.yml")) {
  stop("Run this from the repository root (no _pkgdown.yml here).", call. = FALSE)
}
if (!file.exists(file.path(pkg_src, "DESCRIPTION"))) {
  stop(sprintf(paste0(
    "No package source at '%s'.\n",
    "  This repository holds website content only; the package is documented\n",
    "  from a checkout of giotto-suite/Giotto. Clone it beside this repo:\n",
    "    git clone https://github.com/giotto-suite/Giotto ../Giotto\n",
    "  or point at an existing clone with --pkg <path>."), pkg_src), call. = FALSE)
}
if (!requireNamespace("pkgdown", quietly = TRUE)) {
  stop("pkgdown is not installed: install.packages('pkgdown')", call. = FALSE)
}

DEST  <- normalizePath("docs-preview", mustWork = FALSE)
BUILD <- ".preview-pkgsrc"

# ---- assemble, the same way the workflows do -------------------------------
message("=== assembling ", pkg_src, " + website content -> ", BUILD, " ===")
unlink(BUILD, recursive = TRUE)
dir.create(BUILD, showWarnings = FALSE)

for (f in setdiff(list.files(pkg_src, all.files = TRUE, no.. = TRUE), ".git")) {
  file.copy(file.path(pkg_src, f), BUILD, recursive = TRUE)
}
# REPLACE vignettes/, do not merge: the package ships vignettes that are not in
# this repository's _pkgdown.yml, and pkgdown hard-fails on any missing from the
# index. This repository is the source of truth for tutorials.
unlink(file.path(BUILD, c("vignettes", "pkgdown")), recursive = TRUE)
file.copy("vignettes", BUILD, recursive = TRUE)
file.copy("pkgdown",   BUILD, recursive = TRUE)
file.copy(c("_pkgdown.yml", "index.md"), BUILD, overwrite = TRUE)

desc <- read.dcf(file.path(BUILD, "DESCRIPTION"))
message(sprintf("  documenting %s %s", desc[, "Package"], desc[, "Version"]))

build_one <- function(dev = FALSE) {
  ov <- list(destination = DEST)
  if (dev) {
    Sys.setenv(PKGDOWN_DEV_MODE = "devel")
    banner <- file.path(BUILD, "pkgdown", "dev-banner.html")
    if (file.exists(banner)) {
      ov$template <- list(includes = list(before_body = paste(
        readLines(banner, warn = FALSE), collapse = "\n")))
    }
  } else {
    Sys.unsetenv("PKGDOWN_DEV_MODE")
  }

  pkg <- pkgdown::as_pkgdown(BUILD, override = ov)
  message(sprintf("\n=== building %s -> %s ===",
                  if (dev) "DEV" else "RELEASE", pkg$dst_path))

  t0 <- Sys.time()
  pkgdown::init_site(pkg)
  pkgdown::build_home(pkg, preview = FALSE)
  pkgdown::build_reference(pkg, lazy = FALSE, examples = FALSE, preview = FALSE)
  if (!quick) {
    pkgdown::build_articles(pkg, lazy = FALSE, preview = FALSE)
  } else {
    pkgdown::build_articles_index(pkg)
    message("  (--quick: article pages skipped; links to them will 404)")
  }
  pkgdown::build_news(pkg, preview = FALSE)
  try(pkgdown::build_search(pkg), silent = TRUE)

  message(sprintf("=== done in %.1f min ===",
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))
  invisible(pkg$dst_path)
}

build_one(dev = FALSE)
if (with_dev) build_one(dev = TRUE)

message("\nRelease : ", file.path(DEST, "index.html"))
if (with_dev) message("Dev     : ", file.path(DEST, "dev", "index.html"))

if (serve) {
  # A real HTTP server, not file://, so search (which fetches search.json) and
  # relative asset paths behave as they do in production.
  message("\nServing on http://127.0.0.1:8000/ ",
          if (with_dev) "and http://127.0.0.1:8000/dev/" else "",
          "\nStop with:  pkill -f 'http.server 8000'\n")
  system2("python3", c("-m", "http.server", "8000", "--bind", "127.0.0.1",
                       "--directory", DEST), wait = FALSE)
  Sys.sleep(1)
  utils::browseURL("http://127.0.0.1:8000/")
  if (with_dev) utils::browseURL("http://127.0.0.1:8000/dev/")
}
