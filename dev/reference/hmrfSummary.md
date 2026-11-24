# Compare HMRF settings

One row per
[`runHMRF()`](https://giottosuite.com/dev/reference/runHMRF.md) setting,
to choose `k` and `beta`:

- `loglik`: log-likelihood (grows with `k` and `beta`; compare within a
  `k`);

- `confidence`: mean of each cell's highest posterior probability;

- `coherence`: share of spatial network edges whose two cells are in the
  same domain (higher `beta` gives smoother domains);

- `smallest_domain`: share of cells in the smallest domain (near 0 means
  `k` is too large);

- `iterations` of EM.

## Usage

``` r
hmrfSummary(gobject, spat_unit = NULL, feat_type = NULL, name = "hmrf")
```

## Arguments

- gobject:

  giotto object

- spat_unit, feat_type:

  spatial unit and feature type

- name:

  prefix used in
  [`runHMRF()`](https://giottosuite.com/dev/reference/runHMRF.md)

## Value

A `data.table`, one row per setting.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
g <- runHMRF(g, feats_to_use = "hvf", k = c(4, 6), betas = c(0, 2, 5),
    nstart = 20)
hmrfSummary(g)
```
