# Spatial domains with HMRF

Finds spatial domains with the hidden Markov random field model of Zhu
et al. (2018) (see
[`hmrfParam()`](https://giottosuite.com/dev/reference/hmrfParam.md)) for
one or more `k` and `beta`, so a range of settings is fitted in one
call. For each setting the domains are added to the cell metadata
(column `<name>_k<k>_b<beta>`) and the posterior domain probabilities
stored as a spatial enrichment of the same name. All `beta` share one
k-means start.

The input is either expression of the features in `feats_to_use`, or a
stored spatial enrichment (`spat_enr_name`) such as the module scores of
[`spatialCoexpression()`](https://giottosuite.com/dev/reference/spatialCoexpression.md):
a few spatially informed values per cell that make a fast and stable
start. Selecting spatial genes and building the modules are separate
steps (e.g.
[`spatialAutoCor()`](https://giottosuite.com/dev/reference/spatialAutoCor.md)
with any of its methods, then
[`spatialCoexpression()`](https://giottosuite.com/dev/reference/spatialCoexpression.md)),
so any method that stores a spatial enrichment can feed HMRF. **If you
use it, please cite the original paper** (see References).

## Usage

``` r
runHMRF(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = "scaled",
  feats_to_use = NULL,
  spat_enr_name = NULL,
  spatial_network_name = "Delaunay_network",
  k = 10L,
  betas = 2,
  zscore = NULL,
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
  the name of a logical feature metadata column such as `"hvf"`; ignored
  with `spat_enr_name`

- spat_enr_name:

  name of a spatial enrichment to use instead of expression, e.g. the
  module scores of
  [`spatialCoexpression()`](https://giottosuite.com/dev/reference/spatialCoexpression.md)

- spatial_network_name:

  spatial network

- k:

  integer vector of numbers of domains

- betas:

  numeric vector of `beta` values

- zscore:

  see
  [`hmrfParam()`](https://giottosuite.com/dev/reference/hmrfParam.md);
  `NULL` (default) uses `"feature"` with `spat_enr_name` and `"cell"`
  with expression

- nstart, seed, subsample, maxit, err, label_tol, n_icm:

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

# on spatial co-expression module scores
sv <- spatialAutoCor(g, method = "moran", return_gobject = FALSE)
g <- spatialCoexpression(g, feats = head(sv$feats, 200), n_modules = 8)
g <- runHMRF(g, spat_enr_name = "spatial_module", k = 5, nstart = 20,
    name = "hmrf_modules")
```
