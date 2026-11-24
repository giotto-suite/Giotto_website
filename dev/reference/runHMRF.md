# Spatial domains with HMRF

Finds spatial domains with the hidden Markov random field model of Zhu
et al. (2018) (see
[`hmrfParam()`](https://giottosuite.com/dev/reference/hmrfParam.md)) for
one or more `k` and `beta`, so a range of settings is fitted in one
call. For each setting the domains are added to the cell metadata
(column `<name>_k<k>_b<beta>`) and the posterior domain probabilities
stored as a spatial enrichment of the same name. All `beta` share one
k-means start.

This reimplements the model of smfishHmrf without its spatial gene
selection: pass the features with `feats_to_use`. **If you use it,
please cite the original paper** (see References).

## Usage

``` r
runHMRF(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = "scaled",
  feats_to_use = NULL,
  spatial_network_name = "Delaunay_network",
  k = 10L,
  betas = 2,
  zscore = c("cell", "none"),
  nstart = 200L,
  seed = 100L,
  subsample = 20000L,
  maxit = 50L,
  err = 1e-07,
  label_tol = 1e-04,
  n_icm = 10L,
  name = "hmrf",
  verbose = NULL
)
```

## Arguments

- gobject:

  giotto object

- spat_unit, feat_type:

  spatial unit and feature type

- expression_values:

  expression values (default `"scaled"`)

- feats_to_use:

  features: a character vector (e.g. spatial genes from
  [`binSpect()`](https://giottosuite.com/dev/reference/binSpect.md)) or
  the name of a logical feature metadata column such as `"hvf"`

- spatial_network_name:

  spatial network

- k:

  integer vector of numbers of domains

- betas:

  numeric vector of `beta` values

- zscore, nstart, seed, subsample, maxit, err, label_tol, n_icm:

  see
  [`hmrfParam()`](https://giottosuite.com/dev/reference/hmrfParam.md)

- name:

  prefix of the results

- verbose:

  be verbose

## Value

The giotto object with the domains and probabilities. The spatial
enrichment of each setting keeps its diagnostics in `misc` (see
[`hmrfSummary()`](https://giottosuite.com/dev/reference/hmrfSummary.md)).

## Details

Choosing `k` and `beta`: fit a grid, compare the settings with
[`hmrfSummary()`](https://giottosuite.com/dev/reference/hmrfSummary.md),
then look at the domains with
`spatPlot2D(cell_color = "<name>_k<k>_b<beta>")` and at the
probabilities with
`spatCellPlot2D(spat_enr_names = "<name>_k<k>_b<beta>", cell_annotation_values = paste0("domain_", 1:k))`.

## References

Zhu Q, Shah S, Dries R, Cai L, Yuan GC. Identification of spatially
associated subpopulations by combining scRNAseq and sequential
fluorescence in situ hybridization data. *Nature Biotechnology* 36,
1183–1190 (2018).
[doi:10.1038/nbt.4260](https://doi.org/10.1038/nbt.4260)

## See also

[`hmrfParam()`](https://giottosuite.com/dev/reference/hmrfParam.md),
[`hmrfSummary()`](https://giottosuite.com/dev/reference/hmrfSummary.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
g <- runHMRF(g, feats_to_use = "hvf", k = 5, betas = c(0, 2),
    nstart = 20)
```
