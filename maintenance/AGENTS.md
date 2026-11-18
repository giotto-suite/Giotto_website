# Maintaining the Giotto Suite website

How <https://giottosuite.com> is built and changed. Plain Markdown, for a person
or any AI assistant. If you change how the site is built, update this file in
the same PR.

Related docs:

- **Adding or fixing a tutorial:** `.claude/skills/giotto-tutorial/SKILL.md`
  (procedure) and `RULESET.md` beside it (content).
- **All eight Giotto Suite sites,** the shared workflow's inputs and known
  issues: `GIOTTO_WEBSITES.md` in the GiottoSuite folder (not in a repo).

## How it is built

| branch | workflow | publishes to | documents |
|---|---|---|---|
| `suite` | `.github/workflows/pkgdown.yaml` | <https://giottosuite.com> | `giotto-suite/Giotto@suite` |
| `dev` | `.github/workflows/pkgdown-dev.yaml` | <https://giottosuite.com/dev/> | `giotto-suite/Giotto@gsource` |

- This repository holds the website only: `vignettes/`, `_pkgdown.yml`,
  `index.md`, `pkgdown/` (theme and scripts). The package source is checked out
  from `giotto-suite/Giotto` at build time, at the `package-ref` input. Never
  copy package code in here.
- Both workflows are thin callers of the shared workflow
  `giotto-suite/.github/.github/workflows/pkgdown-site.yaml`. It owns
  dependency installation, the deploy target (`mode: release` → root,
  `mode: dev` → `/dev/`), the dev banner, Rd examples (release only) and the
  concurrency group. Change those there, not here.
- Each workflow first runs `pkgdown/check-site.R`, a structure check that takes
  seconds. The site build only starts if it passes.
- **Dev site pins.** Giotto's `Remotes:` name the default branches, so the dev
  workflow installs `GiottoUtils@main`, `GiottoClass@gsource` and
  `GiottoVisuals@gsource` over them (`pins:`). It then checks versions with
  `expect-versions:`. Any hard dependency only a pinned branch declares is
  installed from CRAN/Bioconductor before the pin. A GitHub-only dependency
  must be added as its own pin, listed earlier.

## Day-to-day

- **Change the dev site:** branch from `dev`, PR into `dev`. Merging rebuilds
  `/dev/` (about 15–20 minutes).
- **Release:** merge `dev` into `suite`. The release build takes about an hour
  because it runs every Rd example.
- **Review before publishing:** build the changed pages locally and get the
  page owner's OK on the rendered HTML before pushing or merging.
  ```sh
  Rscript pkgdown/check-site.R --pkg ../Giotto        # seconds
  Rscript pkgdown/preview-sites.R --dev --pkg ../Giotto
  ```
  The preview needs a Giotto checkout at the branch the site documents
  (`gsource` for dev). `--quick` skips article pages. Output goes to
  `docs-preview/` (git-ignored); stop the server with
  `pkill -f 'http.server 8000'`.
- **Add a tutorial:** follow the tutorial skill. Register it under
  `articles:` (required by the build). Add a `navbar:` entry (expected for new
  tutorials, though only a warning in `check-site.R`) and `tags:`, then run
  `pkgdown/build-browse-pages.R`.
- **Document a different package branch:** Actions → "pkgdown (dev)" → Run
  workflow → `package-ref`, or change its default in `pkgdown-dev.yaml` (and
  the pins with it).
- **A build fails before rendering:** look at the "Pin refs" step first. A
  missing dependency there usually means a pinned branch gained an import.

## Rules that fail silently

1. Keep `development: mode: release` in `_pkgdown.yml`; never `auto`. Dev mode
   comes from `PKGDOWN_DEV_MODE=devel` in the shared workflow.
2. No dev-only presentation in `_pkgdown.yml`. The banner is injected through
   `override=`, so merging `dev` → `suite` cannot carry it to production.
3. Keep `math-rendering: katex`, or Rd maths prints as raw LaTeX.
4. The `cosmo` bootswatch preset rules out `light-switch: true`.
5. Any `*.md` at the repository root is published. Maintainer notes go in
   `maintenance/`.
6. Edit `_pkgdown.yml` as text, never through a YAML writer: its comments and
   section anchors are load-bearing.

## Known issues

- The release deploy uses `clean: false` so it cannot delete `/dev/`. As a
  result, removed or renamed pages stay on `gh-pages` (about 21,700 files in
  November 2026).
- The Docker, Singularity and Terra pages are a work in progress and are not
  linked from the installation page.
- Older tutorials without a navbar entry (41 in November 2026) are left as
  they are; `check-site.R` lists them.
