#!/usr/bin/env Rscript
# Generate vignettes/datasets.Rmd -- a filterable browser over every tutorial
# that carries a `tags:` block in its YAML header.
#
# WHY
# The Examples menu and articles index are organised by platform family, which
# answers "show me Visium" but not "show me human lung", "which tutorials use
# GiottoDisk", or "anything with protein". Tags answer those, and a browser
# page makes them usable without a search backend: the whole index is a few
# dozen cards, filtered in the page by ~60 lines of plain JS.
#
# GENERATED AND COMMITTED, like function_index.Rmd. Re-run it after changing
# any tutorial's tags, or pkgdown/tags.yml, and commit the result:
#
#   Rscript pkgdown/build-dataset-index.R
#
# check-site.R sources this file for its parsing and validation, and fails when
# the committed page is stale, so a forgotten re-run surfaces in CI in seconds.
#
# The vocabulary, and which `articles:` sections must be tagged, live in
# pkgdown/tags.yml.

OUT   <- "vignettes/datasets.Rmd"
VOCAB <- "pkgdown/tags.yml"

`%||%` <- function(a, b) if (is.null(a)) b else a

html_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  gsub('"', "&quot;", x, fixed = TRUE)
}

# Read only the YAML header. rmarkdown::yaml_front_matter() would do, but this
# keeps check-site.R's dependencies at just yaml.
read_front_matter <- function(path) {
  L <- readLines(path, warn = FALSE)
  fence <- which(L == "---")
  if (length(fence) < 2L || fence[[1]] != 1L) return(list())
  yaml::yaml.load(paste(L[seq(2L, fence[[2]] - 1L)], collapse = "\n")) %||% list()
}

# Inventory every tutorial, its section, and its tags, in `articles:` order.
collect_datasets <- function() {
  cfg   <- yaml::read_yaml("_pkgdown.yml")
  vocab <- yaml::read_yaml(VOCAB)

  files <- list.files("vignettes", pattern = "\\.[Rr]md$")
  names(files) <- sub("\\.[Rr]md$", "", files)

  rows <- list()
  for (sec in cfg$articles) {
    for (slug in sec$contents) {
      if (!slug %in% names(files)) next     # check-site.R reports this one
      fm <- read_front_matter(file.path("vignettes", files[[slug]]))
      rows[[length(rows) + 1L]] <- list(
        slug    = slug,
        file    = files[[slug]],
        title   = fm$title %||% slug,
        section = sec$title %||% "",
        tagged  = (sec$title %||% "") %in% vocab$tagged_sections,
        tags    = lapply(fm$tags, as.character)
      )
    }
  }
  list(rows = rows, vocab = vocab, sections = vapply(cfg$articles,
       function(s) s$title %||% "", ""))
}

# Returns a character vector of problems; empty means valid.
validate_datasets <- function(ds) {
  vocab <- ds$vocab
  probs <- character()

  for (s in setdiff(vocab$tagged_sections, ds$sections)) {
    probs <- c(probs, sprintf(paste0(
      "%s: tagged_sections lists '%s', but no `articles:` section has that title.\n",
      "         A section was probably renamed without updating %s."), VOCAB, s, VOCAB))
  }

  for (r in ds$rows) {
    where <- sprintf("vignettes/%s", r$file)
    if (!length(r$tags)) {
      if (r$tagged) {
        probs <- c(probs, sprintf(paste0(
          "%s has no `tags:` block, but every tutorial in '%s' needs one\n",
          "         for the dataset browser. See %s for the vocabulary."),
          where, r$section, VOCAB))
      }
      next
    }
    for (f in setdiff(names(r$tags), names(vocab$facets))) {
      probs <- c(probs, sprintf("%s: unknown tag facet `%s` (known: %s)",
                                where, f, paste(names(vocab$facets), collapse = ", ")))
    }
    for (f in intersect(names(r$tags), names(vocab$facets))) {
      bad <- setdiff(r$tags[[f]], vocab$facets[[f]]$values)
      if (length(bad)) {
        probs <- c(probs, sprintf(paste0(
          "%s: `%s: %s` is not in the vocabulary.\n",
          "         Use one of: %s -- or add it to %s."),
          where, f, paste(bad, collapse = ", "),
          paste(vocab$facets[[f]]$values, collapse = ", "), VOCAB))
      }
    }
    for (f in names(vocab$facets)) {
      if (isTRUE(vocab$facets[[f]]$required) && !length(r$tags[[f]])) {
        probs <- c(probs, sprintf("%s: `tags:` is missing the required facet `%s`",
                                  where, f))
      }
    }
  }
  probs
}

render_datasets <- function(ds) {
  vocab  <- ds$vocab
  facets <- names(vocab$facets)
  rows   <- Filter(function(r) length(r$tags) > 0L, ds$rows)

  # The articles-index section is exposed as its own facet, so "Spatial
  # multi-omics" etc. stay filterable without anyone having to tag them.
  sections <- unique(vapply(rows, `[[`, "", "section"))

  count <- function(f, v) sum(vapply(rows, function(r) v %in% r$tags[[f]], TRUE))

  checkbox <- function(name, value, n) sprintf(paste0(
    '<label class="ds-opt"><input type="checkbox" name="%s" value="%s"%s>',
    ' <span class="ds-lab">%s</span> <span class="ds-n">%d</span></label>'),
    name, html_escape(value), if (n == 0L) " disabled" else "", html_escape(value), n)

  facet_html <- function(key, label, desc, values, counts, featured = FALSE) {
    c(sprintf('<fieldset class="ds-facet%s" data-facet="%s">',
              if (featured) " ds-facet-featured" else "", key),
      sprintf("<legend>%s</legend>", html_escape(label)),
      if (!is.null(desc)) sprintf('<p class="ds-desc">%s</p>', html_escape(desc)),
      '<div class="ds-opts">',
      mapply(checkbox, key, values, counts, USE.NAMES = FALSE),
      "</div>", "</fieldset>")
  }

  side <- character()
  for (f in facets) {
    fc <- vocab$facets[[f]]
    side <- c(side, facet_html(f, fc$label %||% f, fc$desc, fc$values,
                               vapply(fc$values, function(v) count(f, v), 0L),
                               featured = identical(f, "packages")))
    # Category goes right after the featured facet: it is the coarse cut most
    # people make first.
    if (identical(f, "packages")) {
      side <- c(side, facet_html("section", "Category", NULL, sections,
        vapply(sections, function(s) sum(vapply(rows, function(r)
          identical(r$section, s), TRUE)), 0L)))
    }
  }

  card <- function(r) {
    tg   <- r$tags
    attr <- vapply(facets, function(f) sprintf(' data-%s="%s"', f,
                   html_escape(paste(tg[[f]] %||% character(), collapse = "|"))), "")
    meta <- unlist(tg[intersect(c("platform", "species", "tissue", "condition"), names(tg))])
    text <- tolower(paste(r$title, r$section, paste(unlist(tg), collapse = " ")))
    badges <- c(
      sprintf('<span class="ds-badge ds-badge-pkg">%s</span>', html_escape(tg$packages)),
      sprintf('<span class="ds-badge">%s</span>', html_escape(c(tg$modality,
        if (length(tg$panel)) paste(tg$panel, "genes"), tg$resolution))))
    c(sprintf('<a class="ds-card" href="%s.html" data-section="%s"%s data-text="%s">',
              r$slug, html_escape(r$section), paste(attr, collapse = ""), html_escape(text)),
      sprintf('<span class="ds-kind">%s</span>', html_escape(r$section)),
      sprintf('<span class="ds-title">%s</span>', html_escape(r$title)),
      sprintf('<span class="ds-meta">%s</span>', html_escape(paste(meta, collapse = " \u00b7 "))),
      sprintf('<span class="ds-badges">%s</span>', paste(badges, collapse = "")),
      "</a>")
  }

  c("---",
    'title: "Browse datasets"',
    "output:",
    "  html_document:",
    "    toc: false",
    "pkgdown:",
    "  as_is: true",
    "vignette: >",
    "  %\\VignetteIndexEntry{Browse datasets}",
    "  %\\VignetteEngine{knitr::rmarkdown}",
    "  %\\VignetteEncoding{UTF-8}",
    "---",
    "",
    "<!-- GENERATED by pkgdown/build-dataset-index.R from each tutorial's `tags:`",
    "     header and pkgdown/tags.yml. Do not edit by hand: re-run the script. -->",
    "",
    "Filter the example tutorials by platform, species, tissue and more. Within one",
    "filter, any checked value matches; across filters, all must match. The page",
    "address keeps your selection, so a filtered view can be shared as a link.",
    "",
    "```{=html}",
    '<div id="ds-browser" class="ds-browser">',
    '<aside class="ds-side">',
    '<input type="search" id="ds-q" class="form-control" placeholder="Search titles and tags" aria-label="Search datasets">',
    # Collapsible so that on a phone the results are not a screen of
    # checkboxes away. On wider screens CSS hides the toggle and it stays open.
    '<details id="ds-filters" class="ds-filters" open>',
    '<summary>Filters</summary>',
    side,
    "</details>",
    '<button type="button" id="ds-clear" class="btn btn-sm btn-outline-secondary">Clear filters</button>',
    "</aside>",
    '<section class="ds-main">',
    '<p id="ds-count" class="ds-count" aria-live="polite"></p>',
    '<div class="ds-grid">',
    unlist(lapply(rows, card)),
    "</div>",
    '<p id="ds-empty" class="ds-empty" hidden>No tutorials match these filters.</p>',
    "</section>",
    "</div>",
    "<script>",
    strsplit(DS_JS, "\n", fixed = TRUE)[[1]],
    "</script>",
    "```")
}

# Vanilla JS, no dependencies. OR within a facet, AND across facets. The count
# beside each option is how many cards would show if it were toggled on given
# every *other* active filter, which is what makes zero-result clicks visible
# before they happen.
DS_JS <- r"--(
(function () {
  var root = document.getElementById("ds-browser");
  if (!root) return;
  var cards = [].slice.call(root.querySelectorAll(".ds-card"));
  var boxes = [].slice.call(root.querySelectorAll(".ds-facet input[type=checkbox]"));
  var q = document.getElementById("ds-q");
  var filters = document.getElementById("ds-filters");
  if (window.matchMedia && matchMedia("(max-width: 767.98px)").matches) {
    filters.open = false;
  }

  function vals(card, f) {
    var v = card.getAttribute("data-" + f);
    return v ? v.split("|") : [];
  }
  function state() {
    var sel = {};
    boxes.forEach(function (b) {
      if (b.checked) (sel[b.name] = sel[b.name] || []).push(b.value);
    });
    return sel;
  }
  function matches(card, sel, skip, terms) {
    for (var f in sel) {
      if (f === skip) continue;
      var cv = vals(card, f);
      if (!sel[f].some(function (v) { return cv.indexOf(v) >= 0; })) return false;
    }
    var text = card.getAttribute("data-text");
    return terms.every(function (t) { return text.indexOf(t) >= 0; });
  }
  function update() {
    var sel = state();
    var terms = q.value.toLowerCase().split(/\s+/).filter(Boolean);
    var shown = 0;
    cards.forEach(function (c) {
      var ok = matches(c, sel, null, terms);
      c.hidden = !ok;
      if (ok) shown++;
    });
    boxes.forEach(function (b) {
      var n = cards.filter(function (c) {
        return vals(c, b.name).indexOf(b.value) >= 0 && matches(c, sel, b.name, terms);
      }).length;
      b.parentNode.querySelector(".ds-n").textContent = n;
      b.disabled = n === 0 && !b.checked;
      b.parentNode.classList.toggle("ds-off", b.disabled);
    });
    document.getElementById("ds-count").textContent =
      shown + " of " + cards.length + " tutorials";
    document.getElementById("ds-empty").hidden = shown > 0;

    var p = new URLSearchParams();
    for (var f in sel) sel[f].forEach(function (v) { p.append(f, v); });
    if (q.value) p.set("text", q.value);
    var s = p.toString();
    try {
      history.replaceState(null, "", location.pathname + (s ? "?" + s : "") + location.hash);
    } catch (e) {}
  }

  var init = new URLSearchParams(location.search);
  boxes.forEach(function (b) {
    if (init.getAll(b.name).indexOf(b.value) >= 0) b.checked = true;
  });
  // Not `q`: pkgdown's own search reads that and highlights it on the page.
  q.value = init.get("text") || "";
  // A shared link with filters should show them, even on a phone.
  if (boxes.some(function (b) { return b.checked; })) filters.open = true;

  root.addEventListener("change", update);
  q.addEventListener("input", update);
  document.getElementById("ds-clear").addEventListener("click", function () {
    boxes.forEach(function (b) { b.checked = false; });
    q.value = "";
    update();
  });
  update();
})();
)--"

if (sys.nframe() == 0L) {
  if (!file.exists("_pkgdown.yml")) {
    stop("Run this from the repository root (no _pkgdown.yml here).", call. = FALSE)
  }
  ds    <- collect_datasets()
  probs <- validate_datasets(ds)
  if (length(probs)) {
    message(paste0("  x ", probs, collapse = "\n"))
    stop(sprintf("%d tag problem%s; %s not written.", length(probs),
                 if (length(probs) == 1) "" else "s", OUT), call. = FALSE)
  }
  new <- render_datasets(ds)
  old <- if (file.exists(OUT)) readLines(OUT, warn = FALSE) else character()
  writeLines(new, OUT)

  n <- sum(vapply(ds$rows, function(r) length(r$tags) > 0L, TRUE))
  message(sprintf("%s: %d tutorials, %s", OUT, n,
                  if (identical(old, new)) "unchanged" else "UPDATED -- commit it"))
}
