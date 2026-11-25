# Find spatial domains

One command for spatial domains, with two native methods:

- `"neighborhood"`: the BANKSY embedding
  ([`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md),
  Singhal et al. 2024) at `lambda`, clustered by Leiden on an sNN
  network of all its PCs, with the defaults of
  [`GiottoConnect::runBanksy()`](https://giotto-suite.github.io/GiottoConnect/reference/runBanksy.html)
  so the native and original BANKSY can be compared directly;

- `"hmrf"`: the hidden Markov random field
  ([`runHMRF()`](https://giottosuite.com/dev/reference/runHMRF.md), Zhu
  et al. 2018).

**If you use them, please cite the original papers** (see the pages of
[`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md)
and [`runHMRF()`](https://giottosuite.com/dev/reference/runHMRF.md)).

## Usage

``` r
findSpatialDomains(
  gobject,
  method = c("neighborhood", "hmrf"),
  spat_unit = NULL,
  feat_type = NULL,
  feats_to_use = "hvf",
  dim_reduction_to_use = NULL,
  dim_reduction_name = NULL,
  spat_enr_name = NULL,
  k = 10L,
  beta = 2,
  lambda = 0.8,
  resolution = 0.8,
  k_neighbors = 30L,
  seed = 1234L,
  name = "spatial_domain",
  ...
)
```

## Arguments

- gobject:

  giotto object

- method:

  `"neighborhood"` or `"hmrf"`

- spat_unit, feat_type:

  spatial unit and feature type

- feats_to_use:

  features (character vector or a logical feature metadata column such
  as `"hvf"`)

- dim_reduction_to_use, dim_reduction_name:

  `"hmrf"` only: a stored dimension reduction to fit instead of
  expression, such as NMF factors of spatial genes
  ([`runNMF()`](https://giottosuite.com/dev/reference/runNMF.md) on the
  top genes of any
  [`spatialAutoCor()`](https://giottosuite.com/dev/reference/spatialAutoCor.md)
  method); more arguments of
  [`runHMRF()`](https://giottosuite.com/dev/reference/runHMRF.md), e.g.
  `dimensions_to_use`, go through `...`

- spat_enr_name:

  `"hmrf"` only: a spatial enrichment to fit instead of expression, such
  as the module scores of
  [`spatialCoexpression()`](https://giottosuite.com/dev/reference/spatialCoexpression.md)

- k:

  number of domains (`"hmrf"`)

- beta:

  spatial prior strength (`"hmrf"`)

- lambda:

  neighbourhood weight (`"neighborhood"`)

- resolution:

  Leiden resolution (`"neighborhood"`)

- k_neighbors:

  neighbours of the sNN network on all PCs (`"neighborhood"`)

- seed:

  Leiden seed (`"neighborhood"`)

- name:

  name of the cell metadata column with the domains

- ...:

  passed to
  [`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md)
  or [`runHMRF()`](https://giottosuite.com/dev/reference/runHMRF.md)
  (named arguments of
  [`neighborhoodPCAParam()`](https://giottosuite.com/dev/reference/neighborhoodPCAParam.md)
  or
  [`hmrfParam()`](https://giottosuite.com/dev/reference/hmrfParam.md))

## Value

The giotto object with the domains in cell metadata `name`.

## References

Singhal V, Chou N, Lee J, et al. BANKSY unifies cell typing and tissue
domain segmentation for scalable spatial omics data analysis. *Nature
Genetics* 56, 431–441 (2024).
[doi:10.1038/s41588-024-01664-3](https://doi.org/10.1038/s41588-024-01664-3)

Zhu Q, Shah S, Dries R, Cai L, Yuan GC. Identification of spatially
associated subpopulations by combining scRNAseq and sequential
fluorescence in situ hybridization data. *Nature Biotechnology* 36,
1183–1190 (2018).
[doi:10.1038/nbt.4260](https://doi.org/10.1038/nbt.4260)
