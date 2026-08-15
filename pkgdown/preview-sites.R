#!/usr/bin/env Rscript
# Build the Giotto Suite website locally and preview it in a browser.
#
# The contributing guide currently says building locally "may be hard to run
# locally", so most people never see their change before it is live. This is
# the one command that makes it easy.
#
#   Rscript pkgdown/preview-sites.R              # release site only (fast)
#   Rscript pkgdown/preview-sites.R --dev        # release + dev at /dev/
#   Rscript pkgdown/preview-sites.R --quick      # skip articles (~1 min)
#   Rscript pkgdown/preview-sites.R --no-serve   # build, don't open a browser
#
# Run from the repository root.
#
# Notes
#  * Output goes to `docs-preview/` (git-ignored), NOT `docs/`, so a preview can
#    never be mistaken for or overwrite a deploy artifact.
#  * `examples = FALSE` always. Several Rd examples build a Python environment
#    and will shell out to Homebrew/pyenv on a developer machine; on CI they
#    publish their install log into the docs. Previews never need them.
#  * `install = FALSE` matches CI and stops pkgdown installing the package into
#    your library as a side effect.

args     <- commandArgs(trailingOnly = TRUE)
with_dev <- "--dev"      %in% args
quick    <- "--quick"    %in% args
serve    <- !("--no-serve" %in% args)

if (!file.exists("_pkgdown.yml")) {
  stop("Run this from the repository root (no _pkgdown.yml here).")
}
if (!requireNamespace("pkgdown", quietly = TRUE)) {
  stop("pkgdown is not installed: install.packages('pkgdown')")
}

DEST <- "docs-preview"

build_one <- function(dev = FALSE) {
  if (dev) {
    Sys.setenv(PKGDOWN_DEV_MODE = "devel")
    ov <- list(destination = DEST)
    # dev-only presentation is injected here, never in _pkgdown.yml
    if (file.exists("pkgdown/dev-banner.html")) {
      ov$template <- list(includes = list(before_body = paste(
        readLines("pkgdown/dev-banner.html", warn = FALSE), collapse = "\n")))
    }
  } else {
    Sys.unsetenv("PKGDOWN_DEV_MODE")
    ov <- list(destination = DEST)
  }

  pkg <- pkgdown::as_pkgdown(".", override = ov)
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

# Validate the reference index before building. pkgdown aborts on the FIRST
# unmatched topic, so without this a broken index costs a full build to find
# one problem at a time.
if (file.exists("pkgdown/preflight-reference.R")) {
  message("=== pre-flight: resolving the reference index ===")
  try(system2("Rscript", c("pkgdown/preflight-reference.R", ".", "preview")))
}

build_one(dev = FALSE)
if (with_dev) build_one(dev = TRUE)

index <- file.path(DEST, "index.html")
message("\nRelease : ", normalizePath(index, mustWork = FALSE))
if (with_dev) {
  message("Dev     : ",
          normalizePath(file.path(DEST, "dev", "index.html"), mustWork = FALSE))
}

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
