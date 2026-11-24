# Neighborhood PCA (BANKSY embedding)

Computes the BANKSY embedding of Singhal et al. (2024) natively and
stores it as a dimension reduction: each cell's values are joined by the
weighted mean of its spatial neighbours, weighted by `lambda`, and
reduced by PCA (see
[`neighborhoodPCAParam()`](https://giottosuite.com/dev/reference/neighborhoodPCAParam.md)).
Cluster the result with
[`createNearestNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/createNearestNetwork.html)
and
[`doLeidenCluster()`](https://giottosuite.com/dev/reference/doLeidenCluster.md)
(`lambda` about 0.8 for spatial domains, about 0.2 for
neighbourhood-aware cell types).

This reimplements BANKSY's embedding, including its gradient (AGF)
features with `compute_agf = TRUE`. **If you use it, please cite the
original paper** (see References).
[`GiottoConnect::runBanksy()`](https://rdrr.io/pkg/GiottoConnect/man/runBanksy.html)
runs the original Banksy package.

## Usage

``` r
runNeighborhoodPCA(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  input = c("expression", "dim_reduction"),
  expression_values = "normalized",
  feats_to_use = NULL,
  dim_reduction_to_use = "pca",
  dim_reduction_name = NULL,
  dimensions_to_use = NULL,
  spat_loc_name = "raw",
  spatial_network_name = NULL,
  create_network = TRUE,
  lambda = 0.2,
  k_geom = 15L,
  npcs = 20L,
  compute_agf = FALSE,
  absolute = FALSE,
  seed = 1234L,
  name = "neighborhood_pca",
  verbose = NULL
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- input:

  `"expression"` (default) or `"dim_reduction"`: the values the
  neighbourhood is computed on

- expression_values:

  expression values to use with `input = "expression"`

- feats_to_use:

  features to use with `input = "expression"`: a character vector, or
  the name of a logical column of the feature metadata (e.g. `"hvf"`).
  `NULL` uses all features.

- dim_reduction_to_use, dim_reduction_name, dimensions_to_use:

  the embedding to use with `input = "dim_reduction"`

- spat_loc_name:

  name of the spatial locations

- spatial_network_name:

  spatial network(s) of the neighbours: one name, or two with
  `compute_agf = TRUE` (mean and gradient). `NULL` uses the object's
  default spatial network. BANKSY's own definition is a kNN network of
  15 neighbours: `createSpatialNetwork(method = "kNN", k = 15)`.

- create_network:

  logical. When the object has no spatial network, create a kNN network
  of `k_geom` neighbours (`"kNN_network"`, with
  [`createSpatialNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/createSpatialNetwork.html))
  instead of stopping.

- lambda, k_geom, npcs, compute_agf, absolute, seed:

  see
  [`neighborhoodPCAParam()`](https://giottosuite.com/dev/reference/neighborhoodPCAParam.md)

- name:

  name of the stored dimension reduction (reduction method
  `"neighborhood_pca"`)

- verbose:

  be verbose

## Value

The giotto object with the embedding stored as a dimension reduction
(method `"neighborhood_pca"`, name `name`).

## References

Singhal V, Chou N, Lee J, et al. BANKSY unifies cell typing and tissue
domain segmentation for scalable spatial omics data analysis. *Nature
Genetics* 56, 431–441 (2024).
[doi:10.1038/s41588-024-01664-3](https://doi.org/10.1038/s41588-024-01664-3)

## See also

[`neighborhoodPCAParam()`](https://giottosuite.com/dev/reference/neighborhoodPCAParam.md),
[`GiottoConnect::runBanksy()`](https://rdrr.io/pkg/GiottoConnect/man/runBanksy.html)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
g <- runNeighborhoodPCA(g, feats_to_use = "hvf", lambda = 0.8)
g <- createNearestNetwork(g, dim_reduction_to_use = "neighborhood_pca",
    dim_reduction_name = "neighborhood_pca", name = "neighborhood_pca")
g <- doLeidenCluster(g, network_name = "neighborhood_pca",
    name = "nbr_domain")
```
