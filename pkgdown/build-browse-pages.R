#!/usr/bin/env Rscript
# Generate the browse pages -- vignettes/datasets.Rmd and vignettes/tutorials.Rmd
# -- filterable indexes over every tutorial that carries a `tags:` block in its
# YAML header.
#
# WHY
# The navbar menus and articles index are organised by section, which answers
# "show me Visium" or "show me pre-processing" but not "show me human lung",
# "which tutorials use GiottoDisk", or "everything about cell typing". Tags
# answer those, and a browser page makes them usable without a search backend:
# each index is a few dozen cards, filtered in the page by ~60 lines of plain JS.
#
# GENERATED AND COMMITTED, like function_index.Rmd. Re-run it after changing
# any tutorial's tags, or pkgdown/tags.yml, and commit the result:
#
#   Rscript pkgdown/build-browse-pages.R
#
# check-site.R sources this file for its parsing and validation, and fails when
# a committed page is stale, so a forgotten re-run surfaces in CI in seconds.
#
# The vocabularies, and which `articles:` sections feed which page, live in
# pkgdown/tags.yml under `browsers:`.

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

# Inventory every tutorial, its section, its tags and the browser it belongs
# to, in `articles:` order. A tutorial belongs to the browser whose `sections:`
# list its section, unless that browser `exclude:`s it.
collect_tutorials <- function() {
  cfg      <- yaml::read_yaml("_pkgdown.yml")
  browsers <- yaml::read_yaml(VOCAB)$browsers

  files <- list.files("vignettes", pattern = "\\.[Rr]md$")
  names(files) <- sub("\\.[Rr]md$", "", files)

  owner <- function(slug, section) {
    for (b in names(browsers)) {
      if (section %in% browsers[[b]]$sections &&
          !slug %in% browsers[[b]]$exclude) return(b)
    }
    NA_character_
  }

  rows <- list()
  for (sec in cfg$articles) {
    for (slug in sec$contents) {
      if (!slug %in% names(files)) next     # check-site.R reports this one
      fm <- read_front_matter(file.path("vignettes", files[[slug]]))
      section <- sec$title %||% ""
      rows[[length(rows) + 1L]] <- list(
        slug    = slug,
        file    = files[[slug]],
        title   = fm$title %||% slug,
        section = section,
        browser = owner(slug, section),
        tags    = lapply(fm$tags, as.character)
      )
    }
  }
  list(rows = rows, browsers = browsers,
       sections = vapply(cfg$articles, function(s) s$title %||% "", ""))
}

# Returns a character vector of problems; empty means valid.
validate_tutorials <- function(td) {
  probs <- character()

  for (b in names(td$browsers)) {
    for (s in setdiff(td$browsers[[b]]$sections, td$sections)) {
      probs <- c(probs, sprintf(paste0(
        "%s: browsers: %s: sections lists '%s', but no `articles:` section has that title.\n",
        "         A section was probably renamed without updating %s."), VOCAB, b, s, VOCAB))
    }
  }

  for (r in td$rows) {
    where <- sprintf("vignettes/%s", r$file)
    if (is.na(r$browser)) {
      if (length(r$tags)) {
        probs <- c(probs, sprintf(paste0(
          "%s has a `tags:` block, but its section '%s' is not on any browse page.\n",
          "         Remove the tags, or add the section to a browser in %s."),
          where, r$section, VOCAB))
      }
      next
    }
    b     <- td$browsers[[r$browser]]
    facets <- b$facets
    if (!length(r$tags)) {
      probs <- c(probs, sprintf(paste0(
        "%s has no `tags:` block, but every tutorial in '%s' needs one\n",
        "         for %s. See %s for the vocabulary."),
        where, r$section, b$out, VOCAB))
      next
    }
    for (f in setdiff(names(r$tags), names(facets))) {
      probs <- c(probs, sprintf("%s: unknown tag facet `%s` for %s (known: %s)",
                                where, f, b$out, paste(names(facets), collapse = ", ")))
    }
    for (f in intersect(names(r$tags), names(facets))) {
      bad <- setdiff(r$tags[[f]], facets[[f]]$values)
      if (length(bad)) {
        probs <- c(probs, sprintf(paste0(
          "%s: `%s: %s` is not in the vocabulary.\n",
          "         Use one of: %s -- or add it to %s."),
          where, f, paste(bad, collapse = ", "),
          paste(facets[[f]]$values, collapse = ", "), VOCAB))
      }
    }
    for (f in names(facets)) {
      if (isTRUE(facets[[f]]$required) && !length(r$tags[[f]])) {
        probs <- c(probs, sprintf("%s: `tags:` is missing the required facet `%s`",
                                  where, f))
      }
    }
  }
  probs
}

render_browser <- function(td, name) {
  b      <- td$browsers[[name]]
  facets <- names(b$facets)
  rows   <- Filter(function(r) identical(r$browser, name) && length(r$tags) > 0L,
                   td$rows)

  # Optionally expose the articles-index section as its own facet, so e.g.
  # "Spatial multi-omics" stays filterable without anyone having to tag it.
  sections <- unique(vapply(rows, `[[`, "", "section"))
  section_label <- b$section_facet

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
    fc <- b$facets[[f]]
    side <- c(side, facet_html(f, fc$label %||% f, fc$desc, fc$values,
                               vapply(fc$values, function(v) count(f, v), 0L),
                               featured = identical(f, "packages")))
    # The section facet goes right after the featured facet: it is the coarse
    # cut most people make first.
    if (identical(f, "packages") && !is.null(section_label)) {
      side <- c(side, facet_html("section", section_label, NULL, sections,
        vapply(sections, function(s) sum(vapply(rows, function(r)
          identical(r$section, s), TRUE)), 0L)))
    }
  }

  card <- function(r) {
    tg   <- r$tags
    attr <- vapply(facets, function(f) sprintf(' data-%s="%s"', f,
                   html_escape(paste(tg[[f]] %||% character(), collapse = "|"))), "")
    kind <- if (identical(b$kind, "section")) r$section else tg[[b$kind]]
    meta <- unlist(tg[intersect(unlist(b$meta), names(tg))])
    text <- tolower(paste(r$title, r$section, paste(unlist(tg), collapse = " ")))
    badges <- c(
      sprintf('<span class="ds-badge ds-badge-pkg">%s</span>', html_escape(tg$packages)),
      if ("mini" %in% tg$size) '<span class="ds-badge ds-badge-mini">mini</span>',
      sprintf('<span class="ds-badge">%s</span>', html_escape(c(tg$modality,
        if (length(tg$panel)) paste(tg$panel, "genes"), tg$resolution))))
    c(sprintf('<a class="ds-card" href="%s.html" data-section="%s"%s data-text="%s">',
              r$slug, html_escape(r$section), paste(attr, collapse = ""), html_escape(text)),
      sprintf('<span class="ds-kind">%s</span>',
              html_escape(paste(kind, collapse = " · "))),
      sprintf('<span class="ds-title">%s</span>', html_escape(r$title)),
      if (length(meta))
        sprintf('<span class="ds-meta">%s</span>', html_escape(paste(meta, collapse = " · "))),
      if (length(badges))
        sprintf('<span class="ds-badges">%s</span>', paste(badges, collapse = "")),
      "</a>")
  }

  c("---",
    sprintf('title: "%s"', b$title),
    "output:",
    "  html_document:",
    "    toc: false",
    "pkgdown:",
    "  as_is: true",
    "vignette: >",
    sprintf("  %%\\VignetteIndexEntry{%s}", b$title),
    "  %\\VignetteEngine{knitr::rmarkdown}",
    "  %\\VignetteEncoding{UTF-8}",
    "---",
    "",
    "<!-- GENERATED by pkgdown/build-browse-pages.R from each tutorial's `tags:`",
    "     header and pkgdown/tags.yml. Do not edit by hand: re-run the script. -->",
    "",
    "```{=html}",
    if (!is.null(b$intro)) sprintf('<p class="ds-intro">%s</p>', b$intro),
    '<div id="ds-browser" class="ds-browser">',
    '<aside class="ds-side">',
    sprintf(paste0('<input type="search" id="ds-q" class="form-control" ',
                   'placeholder="Search titles and tags" aria-label="Search %s">'),
            name),
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
  td    <- collect_tutorials()
  probs <- validate_tutorials(td)
  if (length(probs)) {
    message(paste0("  x ", probs, collapse = "\n"))
    stop(sprintf("%d tag problem%s; pages not written.", length(probs),
                 if (length(probs) == 1) "" else "s"), call. = FALSE)
  }
  for (name in names(td$browsers)) {
    out <- td$browsers[[name]]$out
    new <- render_browser(td, name)
    old <- if (file.exists(out)) readLines(out, warn = FALSE) else character()
    writeLines(new, out)

    n <- sum(vapply(td$rows, function(r)
      identical(r$browser, name) && length(r$tags) > 0L, TRUE))
    message(sprintf("%s: %d tutorials, %s", out, n,
                    if (identical(old, new)) "unchanged" else "UPDATED -- commit it"))
  }
}
