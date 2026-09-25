---
name: giotto-tutorial
description: Add, convert or fix a tutorial on the Giotto Suite website (giottosuite.com) — writing a new vignettes/*.Rmd, converting an already-rendered tutorial, registering it in _pkgdown.yml under articles:/navbar:, previewing the pkgdown site locally, or debugging a failed site build. Use when working in the Giotto_website repository.
---

# Adding a tutorial to giottosuite.com

This repository holds **website content only** — `vignettes/`, `_pkgdown.yml`, theme,
landing page. The package source is checked out from `giotto-suite/Giotto` at build time
and the website content is laid over it. Never merge package code in here.

## Which branch

Work on **`dev`** (or a branch off it), and PR against `dev`. It publishes to
<https://giottosuite.com/dev/> for review, and reaches the live site only when `dev` is
merged into `suite`.

**Never branch from `suite`** — that publishes straight to the released site with no
review step.

## The procedure

1. **Write `vignettes/<slug>.Rmd`.** Copy the YAML header from any existing tutorial. It
   must contain `pkgdown: as_is: true`, which keeps the tutorial's own `toc` and
   `number_sections` instead of re-rendering into the pkgdown template.

2. **Put figures in `vignettes/images/<slug>/`** and reference them with
   `knitr::include_graphics("images/<slug>/01_plot.png")`. Paths are relative to
   `vignettes/`.

3. **Do not evaluate code that touches Giotto data or files.** Chunks running Giotto are
   `eval=FALSE` and their results are committed PNGs. This is why a tutorial can be
   published for a package that is not even installable in CI. Two exceptions that are
   normal and expected:
   - figure chunks calling only `include_graphics()` **must** evaluate, or no image
     appears. They use `echo=FALSE` so the call itself is hidden.
   - self-contained presentation code — `kableExtra::kable()` over an inline
     `data.frame`, `sprintf()` building image tiles — is fine evaluated.

   A file-level `knitr::opts_chunk$set(eval = FALSE)` in a setup chunk is an alternative
   to per-chunk flags; `stereoseq_importer.Rmd` does it that way.

4. **End with a session-info section**, as existing tutorials do.

5. **Register it in `_pkgdown.yml`.** Two entries, and they are *not* equally important:

   - **`articles:` — required.** Add the slug to the `contents:` list of the section it
     belongs to. pkgdown hard-fails the whole build with "Vignettes missing from index"
     without this, producing nothing.
   - **`navbar:` — optional.** A menu entry pointing at `articles/<slug>.html` makes it
     directly reachable. Skip it for long-tail material: 43 of the 101 tutorials have no
     navbar entry and are reached through `articles/index.html`, which is the documented
     design.

   Edit this file **textually**. Do not round-trip it through a YAML writer — it is ~1000
   hand-commented lines and the comments and section anchors are load-bearing.

6. **Tag it** for the dataset browser (`articles/datasets.html`). Add a `tags:` block
   to the YAML header -- required for tutorials in the Examples sections listed under
   `tagged_sections:` in `pkgdown/tags.yml`, optional elsewhere. `platform`,
   `modality` and `resolution` are required; omit `species`/`tissue`/`condition` when
   the dataset does not state them rather than guessing. Use `packages: GiottoDisk`
   when the tutorial works on a disk-backed object, `packages: GiottoLens` for the
   interactive viewer. Values must be in `pkgdown/tags.yml`. Then regenerate and
   commit the page:
   ```sh
   Rscript pkgdown/build-dataset-index.R
   ```

7. **Check, in about a second:**
   ```sh
   Rscript pkgdown/check-site.R
   ```
   Errors mean a build would fail or publish a dead link. Warnings are informational and
   are expected in the current tree (see its header for why).

8. **Preview** (needs a `../Giotto` clone, or `--pkg <path>`):
   ```sh
   Rscript pkgdown/preview-sites.R --dev --quick
   ```
   `--quick` skips article pages, so it is about a minute; drop it to render your
   tutorial. Runs `check-site.R` first and refuses to build on errors.

9. **PR against `dev`.** The dev site rebuilds in roughly 5–10 minutes. A release build
   takes 40–70 because it also runs every Rd example.

## Converting an already-rendered tutorial

If the tutorial exists as a fully-evaluated `.Rmd` plus its rendered `.html`:

```sh
Rscript pkgdown/convert-tutorial.R path/to/source.Rmd path/to/rendered.html <slug>
```

It extracts and downsizes the figures, matches each to the chunk that produced it, flips
every chunk to `eval = FALSE`, and inserts the `include_graphics()` calls. It refuses to
run if the `.html` is older than the `.Rmd`, because that silently produces figures which
do not match the printed code. You still do step 5 yourself.

## Things that fail silently

- **Renaming an `articles:` section breaks the navbar links into it.** Each section's
  `desc:` carries a `<span id="...">` that ~11 navbar entries deep-link to via
  `articles/index.html#<anchor>`. Rename a section and you must update the anchor and
  every href. `check-site.R` catches this.
- **Any `*.md` at the repository root gets published** as
  `giottosuite.com/<name>.html` — pkgdown globs the root with no opt-out. Maintainer
  notes go in `maintenance/`, not the root.
- **`math-rendering: katex` is required.** The default relies on pandoc, and Rd maths
  from `\deqn{}`/`\eqn{}` never passes through pandoc.
- **Never set `development: mode: auto`.** Release and dev sources carry the same
  version, so version detection cannot tell them apart, and a stray `.9000` would
  relocate the production site into `/dev/`. Dev mode is forced by
  `PKGDOWN_DEV_MODE=devel` in CI instead.
- **Never put dev-only presentation in `_pkgdown.yml`.** The dev banner is injected
  through the workflow's `override=` precisely so merging `dev` → `suite` cannot carry it
  into production.

## Reference documentation is not here

Function help pages come from the **package** repositories. Edit the roxygen in
`giotto-suite/Giotto`, regenerate `man/`, and the site picks it up on its next build.
Every documented topic must be either listed under `reference:` in `_pkgdown.yml` or
marked `@keywords internal` — pkgdown hard-fails on any topic that is neither, and there
is no third option. `check-site.R` verifies this too when a package clone is beside this
repository (`--pkg`, default `../Giotto`), so a new exported function shows up as an
error in a second rather than an hour into the build.

For site architecture across all the Giotto Suite sites, the shared workflow's inputs,
and known issues, see `GIOTTO_WEBSITES.md` in the suite root (outside this repository).
