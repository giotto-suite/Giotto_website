# Multi omics integration with block-weighted PCs

Joint embedding of two or more feature types from their own dimension
reductions (multiblock PCA with block scaling; Westerhuis et al. 1998,
*J Chemometrics* 12:301). Each feature type's coordinates (a block) are
divided by the square root of their total variance, so no block
dominates by its number of dimensions or its scale, multiplied by the
square root of its weight and concatenated. With `rotate = TRUE` the
concatenation is rotated to its principal axes, so its dimensions are
ordered by variance as in a PCA; a rotation keeps all distances, so
neighbors computed on all dimensions are the same either way.

Memory and time are linear in the number of cells (one N x d matrix, d
the dimensions summed over the feature types), so this scales to whole
slides and works on GiottoDisk-backed objects.

## Usage

``` r
runBlockPCA(
  gobject,
  spat_unit = "cell",
  feat_types = c("rna", "protein"),
  reduction_methods = c("pca", "pca"),
  reduction_names = NULL,
  dimensions_to_use = NULL,
  block_weights = NULL,
  rotate = TRUE,
  name = "blockpca",
  integrated_k = 20,
  integrated_network_name = paste0(name, "_kNN"),
  integrated_snn = c("none", "giotto", "jaccard"),
  snn_prune = 1/15,
  integrated_snn_name = NULL,
  engine = c("dbscan", "hnsw"),
  n_threads = NULL,
  verbose = FALSE
)
```

## Arguments

- gobject:

  A Giotto object with a dimension reduction (e.g. PCA) for each feature
  type in `feat_types`.

- spat_unit:

  spatial unit

- feat_types:

  feature types to integrate (two or more). The joint embedding is
  stored under each of them.

- reduction_methods:

  reduction method of each feature type's embedding. Default
  `c("pca", "pca")`.

- reduction_names:

  name of each feature type's embedding. `NULL` (default) uses the names
  [`runPCA()`](https://giottosuite.com/dev/reference/runPCA.md) gives:
  `"pca"` for `rna`, `"<feat_type>.pca"` otherwise.
  `list_dim_reductions(gobject)` lists the stored names.

- dimensions_to_use:

  dimensions (indices) of each embedding to use: one integer vector for
  all feature types, or a list with one per feature type (named by
  feature type, or in the order of `feat_types`). Indices beyond those
  stored are dropped. `NULL` (default): all stored dimensions.

- block_weights:

  share of the joint variance given to each feature type. `NULL`
  (default) weights them equally; otherwise one positive number per
  feature type (named by feature type, or in the order of `feat_types`),
  rescaled to sum to 1.

- rotate:

  logical. Rotate the joint embedding to its principal axes (default
  `TRUE`).

- name:

  name of the stored embedding. Default `"blockpca"`.

- integrated_k:

  number of neighbors of each cell in the integrated kNN, searched on
  all dimensions of the joint embedding. Default 20.

- integrated_network_name:

  name of the integrated kNN network, stored as a `kNN` network under
  `feat_types[1]`. Default `"<name>_kNN"`.

- integrated_snn:

  shared nearest neighbor network of the integrated kNN to store for
  clustering, as an `sNN` network named `integrated_snn_name` under
  `feat_types[1]`, as in
  [`runWNN()`](https://giottosuite.com/dev/reference/runWNN.md).
  `"none"` (default) stores no sNN; `"giotto"` keeps the kNN edges whose
  cells share at least 5 neighbors, plus each cell's 3 strongest (as
  `createNearestNetwork(type = "sNN")`); `"jaccard"` weights every kNN
  edge by the Jaccard overlap of the two cells' neighbor sets and drops
  edges below `snn_prune`.

- snn_prune:

  smallest Jaccard overlap kept with `integrated_snn = "jaccard"`.
  Default 1/15.

- integrated_snn_name:

  name of the sNN network. `NULL` (default): `integrated_network_name`
  with `"kNN"` replaced by `"sNN"`.

- engine:

  neighbor search: `"dbscan"` (exact, default) or `"hnsw"` (approximate,
  faster on large data).

- n_threads:

  threads of the `"hnsw"` search. `NULL`: its default.

- verbose:

  be verbose

## Value

The Giotto object with the joint embedding stored, for every feature
type in `feat_types`, as reduction method `"blockpca"` named `name`; the
integrated kNN (`integrated_network_name`) and, unless
`integrated_snn = "none"`, its sNN (`integrated_snn_name`) under
`feat_types[1]`. Cluster with
`doLeidenCluster(feat_type = feat_types[1], nn_network_to_use = "sNN", network_name = integrated_snn_name)`
and embed with
`runIntegratedUMAP(graph = "knn", network_name = integrated_network_name)`,
as for [`runWNN()`](https://giottosuite.com/dev/reference/runWNN.md).

## Details

For block b with selected coordinates X_b (cells x d_b) and weight w_b,
the joint embedding is `[X_1 s_1, ..., X_B s_B]` with
`s_b = sqrt(w_b / sum_j var(X_b[, j]))`, so block b holds w_b of the
total variance (1). The rotation centers the joint embedding and
projects it on the eigenvectors of its covariance, each signed so that
its largest entry is positive.

Stored in the `misc` slot of each dimension reduction: `eigenvalues`
(the variance of each joint dimension; `NULL` without rotation) and
`block_input`, with the feature types, embeddings and dimensions used,
the weights, the scale factors s_b, and `block_share`, the share of each
joint dimension's variance that comes from each block.

Unlike [`runWNN()`](https://giottosuite.com/dev/reference/runWNN.md),
the weights are the same for every cell.

## See also

[`runWNN()`](https://giottosuite.com/dev/reference/runWNN.md),
[`runIntegratedUMAP()`](https://giottosuite.com/dev/reference/runIntegratedUMAP.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
x <- getExpression(g, values = "raw", output = "matrix")[1:30, ]
g <- setExpression(g, createExprObj(x, name = "raw", feat_type = "protein"))
g <- normalizeGiotto(g, feat_type = "protein", verbose = FALSE)
g <- runPCA(g, feat_type = "protein", feats_to_use = NULL, ncp = 10)

g <- runBlockPCA(g, feat_types = c("rna", "protein"),
    dimensions_to_use = list(1:10, 1:10), integrated_k = 10,
    integrated_snn = "giotto")
getDimReduction(g, reduction_method = "blockpca", name = "blockpca",
    output = "matrix")[1:3, 1:3]
g <- doLeidenCluster(g, nn_network_to_use = "sNN",
    network_name = "blockpca_sNN", name = "cluster_block")
g <- runIntegratedUMAP(g, graph = "knn", network_name = "blockpca_kNN",
    k = 10, name = "umap_block")
```
