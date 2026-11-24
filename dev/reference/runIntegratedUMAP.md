# Run integrated UMAP

UMAP of the integrated neighbors made by
[`runWNN()`](https://giottosuite.com/dev/reference/runWNN.md), with the
same `graph`:

- `"dense"` (default, Giotto 4.3.6 and earlier, unchanged): builds the
  integrated kNN from the N x N affinity matrix of
  `runWNN(graph = "dense")` unless one is stored (`force = TRUE`
  rebuilds it), and embeds it.

- `"knn"`: uwot embeds the integrated kNN network of
  `runWNN(graph = "knn")` or
  [`runBlockPCA()`](https://giottosuite.com/dev/reference/runBlockPCA.md)
  directly (`nn_method`), so no data matrix is needed.

Arguments marked "`dense` only" or "`knn` only" are ignored, with a
warning, by the other `graph`.

## Usage

``` r
runIntegratedUMAP(
  gobject,
  spat_unit = "cell",
  feat_types = c("rna", "protein"),
  integrated_feat_type = NULL,
  integration_method = "WNN",
  matrix_result_name = "theta_weighted_matrix",
  k = 20,
  spread = 5,
  min_dist = 0.01,
  force = FALSE,
  seed = 1234,
  graph = c("dense", "knn"),
  network_name = "integrated_kNN",
  name = "integrated.umap",
  ...
)
```

## Arguments

- gobject:

  A giotto object

- spat_unit:

  spatial unit

- feat_types:

  feature types that were integrated. The UMAP is stored under each of
  them; the integrated kNN is read from the first.

- integrated_feat_type:

  (`dense` only) integrated feature type (e.g. 'rna_protein')

- integration_method:

  (`dense` only) multiomics integration method used. Default = 'WNN'

- matrix_result_name:

  (`dense` only) Default = 'theta_weighted_matrix'

- k:

  number of neighbors (self excluded). With `graph = "knn"`, taken from
  the integrated kNN (at most `runWNN(integrated_k =)`).

- spread:

  UMAP param: spread

- min_dist:

  UMAP param: min_dist

- force:

  (`dense` only) force calculation of integrated kNN. Default = FALSE

- seed:

  seed. Default 1234

- graph:

  `"dense"` (default) or `"knn"`, as used in
  [`runWNN()`](https://giottosuite.com/dev/reference/runWNN.md).

- network_name:

  (`knn` only) name of the integrated kNN network made by
  [`runWNN()`](https://giottosuite.com/dev/reference/runWNN.md) or
  [`runBlockPCA()`](https://giottosuite.com/dev/reference/runBlockPCA.md).
  Default `"integrated_kNN"`.

- name:

  (`knn` only) name of the stored UMAP. Default `"integrated.umap"` (the
  name `graph = "dense"` uses).

- ...:

  additional parameters for
  [`uwot::umap()`](https://jlmelville.github.io/uwot/reference/umap.html)
  (e.g. `n_threads`)

## Value

A Giotto object with the integrated UMAP stored as a `umap` reduction
for every feature type in `feat_types`.
