# Shelved tutorials

Tutorials taken off the site, kept to revisit. pkgdown builds only
`vignettes/`, so nothing here is published; their old URLs redirect to the
articles index (`_pkgdown.yml`, `redirects:`).

- `interactive_giotto_vitessceR.Rmd`, `interactive_selection_cosmx.Rmd`:
  vitessceR views of an AnnData-Zarr export. `giottoToAnndataZarr()` was
  retired (Giotto 4.3.7); revisit with a Zarr export in GiottoConnect.
  To restore one, move it and its `images/` folder back to `vignettes/` and
  list it in `_pkgdown.yml`.
- `bento.Rmd`: subcellular analysis with Bento via
  `GiottoConnect::createBentoAdata()`, written for the conda Python
  environment; taken off until it is redone with the worker-session Python
  setup.
