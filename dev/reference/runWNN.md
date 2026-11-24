# Multi omics integration with WNN

Weighted nearest neighbor (WNN) integration of feature types (Hao et al.
2021, *Cell* 184:3573). For each cell and modality, the modality's own
neighbors are compared with the other modalities' neighbors at
predicting the cell's embedding; a softmax over those scores gives
per-cell modality weights, which weight the cell-cell affinities of the
integrated neighbors.

`graph` chooses how the integrated neighbors are found:

- `"dense"` (default): the method of Giotto 4.3.6 and earlier,
  unchanged. Two feature types; the weighted affinity of every pair of
  cells is stored as a dense N x N matrix (`matrix_result_name`), from
  which
  [`runIntegratedUMAP()`](https://giottosuite.com/dev/reference/runIntegratedUMAP.md)
  builds the integrated kNN. Memory and time grow with N^2: each N x N
  matrix takes 8 N^2 bytes (0.75 GB at 10,000 cells, 19 GB at 50,000),
  and a message says so from 20,000 cells.

- `"knn"`: the WNN paper's kernel on k-nearest-neighbor lists only
  (memory O(N knn_range), time linear in N), so it scales to whole
  slides and GiottoDisk-backed objects. Two or more feature types. The
  integrated kNN keeps, for every cell, the `integrated_k` cells with
  the highest weighted affinity among the union of each modality's
  `knn_range` nearest neighbors, and is stored as a network. Scores are
  capped and the softmax is computed in log-sum-exp form, so weights are
  always finite. Use `runIntegratedUMAP(graph = "knn")` with it.

Arguments marked "`knn` only" are ignored, with a warning, by
`graph = "dense"`.

## Usage

``` r
runWNN(
  gobject,
  spat_unit = "cell",
  feat_types = c("rna", "protein"),
  reduction_methods = c("pca", "pca"),
  reduction_names = NULL,
  k = 20,
  integrated_feat_type = NULL,
  matrix_result_name = NULL,
  w_names = NULL,
  verbose = FALSE,
  graph = c("dense", "knn"),
  network_names = NULL,
  dimensions_to_use = NULL,
  l2_norm = TRUE,
  score_cap = 200,
  knn_range = 200,
  integrated_k = k,
  integrated_network_name = "integrated_kNN",
  integrated_snn = c("none", "giotto", "jaccard"),
  snn_prune = 1/15,
  integrated_snn_name = NULL,
  engine = c("dbscan", "hnsw"),
  n_threads = NULL,
  add_to_metadata = FALSE
)
```

## Arguments

- gobject:

  A Giotto object with a dimension reduction (e.g. PCA) for each feature
  type in `feat_types`.

- spat_unit:

  spatial unit

- feat_types:

  feature types to integrate. The integrated kNN is stored under the
  first one.

- reduction_methods:

  reduction method of each feature type's embedding. Default
  `c("pca", "pca")`.

- reduction_names:

  name of each feature type's embedding. `NULL` (default): for each
  feature type, the stored `"<feat_type>.<method>"` embedding, else
  `"<method>"`, so both the names of earlier defaults (`"rna.pca"`) and
  those [`runPCA()`](https://giottosuite.com/dev/reference/runPCA.md)
  gives (`"pca"`, `"protein.pca"`) are found.
  `list_dim_reductions(gobject)` lists the stored names.

- k:

  number of nearest neighbors per modality used for the modality
  predictions and the kernel bandwidths. With `graph = "dense"` they are
  read from each feature type's stored kNN network.

- integrated_feat_type:

  name under which the results are stored in the multiomics slot.
  Default: the feature types joined by `"_"` (e.g. `"rna_protein"`).

- matrix_result_name:

  name of the stored affinity matrix. `"dense"`: the N x N matrix of all
  cell pairs, `NULL` (default) gives `"theta_weighted_matrix"`. `"knn"`:
  `NULL` (default) stores none; a name stores the affinity restricted to
  the integrated kNN as a sparse N x N `dgCMatrix` (N x `integrated_k`
  non-zeros).

- w_names:

  names of the stored weights, one per feature type. `NULL` (default)
  gives `"w_<feat_type>"`.

- verbose:

  be verbose

- graph:

  `"dense"` (default, Giotto 4.3.6 and earlier) or `"knn"` (scales to
  whole slides); see Description.

- network_names:

  (`knn` only) `NULL` or the name of a stored kNN network for each
  feature type whose neighbors are used instead of a new search (all
  distances are still computed in the embedding).

- dimensions_to_use:

  (`knn` only) dimensions (indices) of each embedding to use: one
  integer vector for all feature types, or a list with one per feature
  type. Indices beyond those stored are dropped. `NULL` (default): the
  dimensions recorded on the feature type's kNN network built from the
  same embedding (`network_names`, else the first stored kNN network),
  else all stored dimensions.

- l2_norm:

  (`knn` only) logical. L2-normalize each cell's embedding before any
  distance is computed (the WNN paper's default). Default `TRUE`.

- score_cap:

  (`knn` only) upper limit of the modality scores before the softmax
  (default 200, as in the WNN paper). `Inf` leaves them uncapped; the
  softmax is stable either way.

- knn_range:

  (`knn` only) number of nearest neighbors (self excluded) per modality
  searched as candidates for the integrated kNN.

- integrated_k:

  (`knn` only) number of neighbors (self excluded) in the integrated
  kNN. Default `k`.

- integrated_network_name:

  (`knn` only) name of the integrated kNN network, stored as a `kNN`
  network under `feat_types[1]`.

- integrated_snn:

  (`knn` only) shared nearest neighbor network of the integrated kNN to
  store for clustering, as an `sNN` network named `integrated_snn_name`
  under `feat_types[1]`. `"none"` (default) stores no sNN. `"giotto"`
  builds it as `createNearestNetwork(type = "sNN")` does: the kNN edges
  whose cells share at least 5 neighbors, plus each cell's 3 edges with
  the most shared neighbors, weighted `1 / (1 + distance)`. `"jaccard"`
  links every two cells whose neighbor sets overlap, weighted by their
  Jaccard index (shared / (2 `integrated_k` - shared)), and drops links
  below `snn_prune`.

- snn_prune:

  (`knn` only) smallest Jaccard index kept with
  `integrated_snn = "jaccard"`. Default 1/15.

- integrated_snn_name:

  (`knn` only) name of the sNN network. `NULL` (default):
  `integrated_network_name` with `"kNN"` replaced by `"sNN"`.

- engine:

  (`knn` only) nearest neighbor search: `"dbscan"` (exact, default) or
  `"hnsw"` (approximate, multithreaded; see
  [`GiottoClass::hnswKNN()`](https://giotto-suite.github.io/GiottoClass/reference/hnswKNN.html)).
  The search for `knn_range` neighbors dominates the run time on large
  data, and `"hnsw"` is several times faster there: use it for whole
  slides.

- n_threads:

  (`knn` only) threads for `engine = "hnsw"`. `NULL` uses
  [`GiottoUtils::determine_cores()`](https://giotto-suite.github.io/GiottoUtils/reference/determine_cores.html).

- add_to_metadata:

  (`knn` only) logical. Also add the weights as cell metadata columns
  (named by `w_names`) for every feature type in `feat_types`. Default
  `FALSE`.

## Value

The Giotto object with, in the multiomics slot under
`integrated_feat_type` and `"WNN"`, one weight vector per feature type
(`w_names`). `"dense"`: also the N x N affinity matrix
(`matrix_result_name`). `"knn"`: the integrated kNN network
(`integrated_network_name`) under `feat_types[1]`, with `integrated_snn`
its sNN (`integrated_snn_name`); and, with `add_to_metadata = TRUE`, the
weights as cell metadata.

## Details

`graph = "knn"`, for modality m with embedding X_m and k neighbors
N_m(i) of cell i: rho_m(i) is the distance to the nearest neighbor; the
within-modality prediction is the mean of X_m over N_m(i), the
cross-modality prediction from modality o the mean of X_m over N_o(i).
The bandwidth b_m(i) is the mean distance (minus rho_m(i)) to the k + 1
cells of lowest non-zero Jaccard similarity in the shared-neighbor
graph, as in the WNN paper. theta = exp(-max(d - rho, 0) / b) for the
distance d between X_m(i) and each prediction, and S_m,o = theta_within
/ (theta_cross,o + 1e-4), capped to `[0, score_cap]`. The weight of m is
sum_o exp(S_m,o) / sum_m' sum_o exp(S_m',o). A zero bandwidth (identical
profiles) gives theta = 1 when the distance equals rho and 0 otherwise.
The integrated affinity of a candidate pair is T(a, b) = sum_m w_m(a)
exp(-max(D_m(a, b) - rho_m(a), 0) / b_m(a)). The integrated kNN keeps
the top `integrated_k` by T (ties by cell order); its edges carry
`distance = sqrt(min(max((1 - T) / 2, 0), 1))`,
`weight = 1 / (1 + distance)` and `affinity = T`.

## See also

[`runIntegratedUMAP()`](https://giottosuite.com/dev/reference/runIntegratedUMAP.md);
with `graph = "knn"`, cluster with
`doLeidenCluster(feat_type = feat_types[1], nn_network_to_use = "kNN", network_name = "integrated_kNN")`,
or on the sNN made with `integrated_snn = "giotto"`.
