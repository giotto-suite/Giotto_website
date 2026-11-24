# Spatial domains with BANKSY

Runs BANKSY (Singhal et al. 2024, *Nat Genet* 56:431) through the
Bioconductor package Banksy on a stored dimension reduction: each cell's
coordinates are joined by the mean of its spatial neighbors' (and, with
`compute_agf = TRUE`, their azimuthal gradient), weighted by `lambda`,
and reduced by PCA; the BANKSY PCs are then clustered with Leiden into
domains. The defaults are the BANKSY authors' settings for finding
domains. With a joint embedding such as
[`runBlockPCA()`](https://giottosuite.com/dev/reference/runBlockPCA.md)'s,
the domains use RNA and protein together.

Only the embedding (cells x dimensions) and the spatial locations are
passed to Banksy, never the expression, so GiottoDisk-backed objects
work as in-memory ones.

## Usage

``` r
runBanksy(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  dim_reduction_to_use = "pca",
  dim_reduction_name = NULL,
  dimensions_to_use = NULL,
  spat_loc_name = "raw",
  lambda = 0.8,
  k_geom = 30,
  compute_agf = FALSE,
  npcs = 20,
  cluster_method = c("giotto", "banksy"),
  k_neighbors = 50,
  nn_engine = c("dbscan", "hnsw"),
  resolution = 0.8,
  name = "banksy",
  seed = 1234,
  verbose = NULL
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type of the dimension reduction; the domains are added to its
  cell metadata

- dim_reduction_to_use:

  reduction method of the embedding, e.g. `"pca"` or `"blockpca"`

- dim_reduction_name:

  name of the embedding. `NULL` takes the default name of
  `dim_reduction_to_use` for `feat_type`.

- dimensions_to_use:

  dimensions (indices) of the embedding to use. `NULL` (default) uses
  all; indices beyond those stored are dropped.

- spat_loc_name:

  name of the spatial locations

- lambda:

  weight of the neighborhood in `[0, 1]`: about 0.8 finds spatial
  domains, about 0.2 refines cell types with their surroundings

- k_geom:

  number of spatial neighbors for the neighborhood mean and, with
  `compute_agf = TRUE`, for the azimuthal gradient

- compute_agf:

  logical. Also use the azimuthal Gabor filter (gradient) of the
  neighborhood

- npcs:

  number of PCs of the BANKSY matrix used for clustering

- cluster_method:

  `"giotto"` (default): a shared nearest neighbor network of the BANKSY
  PCs
  ([`createNearestNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/createNearestNetwork.html),
  stored as `name`) and
  [`doLeidenCluster()`](https://giottosuite.com/dev/reference/doLeidenCluster.md)
  run to convergence. `"banksy"`: `Banksy::clusterBanksy()`, BANKSY's
  own graph and Leiden; on 146,000 cells it takes about 5 minutes on one
  thread and about 10 GB for its graph.

- k_neighbors:

  neighbors of the clustering network

- nn_engine:

  `"giotto"` clustering: neighbor search of
  [`createNearestNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/createNearestNetwork.html),
  exact (`"dbscan"`) or approximate (`"hnsw"`, faster on whole slides)

- resolution:

  Leiden resolution

- name:

  name of the cell metadata column with the domains, and of the stored
  BANKSY PCs (reduction method `"banksy"`)

- seed:

  seed

- verbose:

  be verbose

## Value

The Giotto object with the domains in the cell metadata of `feat_type`
(column `name`) and the BANKSY PCs as a dimension reduction (method
`"banksy"`, name `name`); with `cluster_method = "giotto"` also the sNN
network `name`.

## See also

[`runBlockPCA()`](https://giottosuite.com/dev/reference/runBlockPCA.md)
for a joint RNA + protein embedding.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

g <- runBanksy(g, dimensions_to_use = 1:20, npcs = 10, k_geom = 6,
    resolution = 0.5)
table(pDataDT(g)$banksy)
```
