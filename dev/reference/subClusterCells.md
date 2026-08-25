# Cell subclustering

Perform cell subclustering by taking an annotated group of cells and
performing another round of clustering on just that subset. Several
methods are implemented. `subClusterCells()` is the main wrapper
function. `doLeidenSubCluster()` and `doLouvainSubCluster()` are more
specific implementations.

## Usage

``` r
subClusterCells(
  gobject,
  name = "sub_clus",
  cluster_method = c("leiden", "louvain_community", "louvain_multinet"),
  cluster_column = NULL,
  selected_clusters = NULL,
  hvg_param = deprecated(),
  hvf_param = list(reverse_log_scale = TRUE, difference_in_cov = 1, expression_values =
    "normalized"),
  hvg_min_perc_cells = deprecated(),
  hvf_min_perc_cells = 5,
  hvg_mean_expr_det = deprecated(),
  hvf_mean_expr_det = 1,
  use_all_genes_as_hvg = deprecated(),
  use_all_feats_as_hvf = FALSE,
  min_nr_of_hvg = deprecated(),
  min_nr_of_hvf = 5,
  pca_param = list(expression_values = "normalized", scale_unit = TRUE),
  nn_param = list(dimensions_to_use = 1:20),
  k_neighbors = 10,
  resolution = 1,
  n_iterations = 1000,
  gamma = 1,
  omega = 1,
  python_path = NULL,
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  return_gobject = TRUE,
  verbose = TRUE
)

doLeidenSubCluster(
  gobject,
  feat_type = NULL,
  name = "sub_leiden_clus",
  cluster_column = NULL,
  selected_clusters = NULL,
  hvf_param = list(reverse_log_scale = TRUE, difference_in_cov = 1, expression_values =
    "normalized"),
  hvg_param = deprecated(),
  hvf_min_perc_cells = 5,
  hvg_min_perc_cells = deprecated(),
  hvf_mean_expr_det = 1,
  hvg_mean_expr_det = deprecated(),
  use_all_feats_as_hvf = FALSE,
  use_all_genes_as_hvg = deprecated(),
  min_nr_of_hvf = 5,
  min_nr_of_hvg = deprecated(),
  pca_param = list(expression_values = "normalized", scale_unit = TRUE),
  nn_param = list(dimensions_to_use = 1:20),
  k_neighbors = 10,
  resolution = 0.5,
  n_iterations = 500,
  python_path = NULL,
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  return_gobject = TRUE,
  toplevel = 2,
  verbose = TRUE
)

doLouvainSubCluster(
  gobject,
  name = "sub_louvain_clus",
  version = c("community", "multinet"),
  cluster_column = NULL,
  selected_clusters = NULL,
  hvg_param = deprecated(),
  hvf_param = list(reverse_log_scale = TRUE, difference_in_cov = 1, expression_values =
    "normalized"),
  hvg_min_perc_cells = deprecated(),
  hvf_min_perc_cells = 5,
  hvg_mean_expr_det = deprecated(),
  hvf_mean_expr_det = 1,
  use_all_genes_as_hvg = deprecated(),
  use_all_feats_as_hvf = FALSE,
  min_nr_of_hvg = deprecated(),
  min_nr_of_hvf = 5,
  pca_param = list(expression_values = "normalized", scale_unit = TRUE),
  nn_param = list(dimensions_to_use = 1:20),
  k_neighbors = 10,
  resolution = 0.5,
  gamma = 1,
  omega = 1,
  python_path = NULL,
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  return_gobject = TRUE,
  verbose = TRUE
)
```

## Arguments

- gobject:

  `giotto` object

- name:

  name for new clustering result

- cluster_method:

  clustering method to use. Currently one of "leiden" (default),
  "louvain_community", "louvain_multinet"

- cluster_column:

  cluster column to subcluster

- selected_clusters:

  only do subclustering on these clusters

- hvg_param:

  deprecated

- hvf_param:

  list of parameters for
  [`calculateHVF()`](https://giottosuite.com/dev/reference/calculateHVF.md)

- hvg_min_perc_cells:

  deprecated

- hvf_min_perc_cells:

  threshold for detection in min percentage of cells

- hvg_mean_expr_det:

  deprecated

- hvf_mean_expr_det:

  threshold for mean expression level in cells with detection

- use_all_genes_as_hvg:

  deprecated

- use_all_feats_as_hvf:

  forces all features to be HVF and to be used as input for PCA

- min_nr_of_hvg:

  deprecated

- min_nr_of_hvf:

  minimum number of HVF, or all features will be used as input for PCA

- pca_param:

  list of parameters for
  [`runPCA()`](https://giottosuite.com/dev/reference/runPCA.md)

- nn_param:

  list of parameters for
  [`createNearestNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/createNearestNetwork.html)

- k_neighbors:

  number of k for
  [`createNearestNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/createNearestNetwork.html)

- resolution:

  resolution for community algorithm

- n_iterations:

  number of iterations to run the Leiden algorithm.

- gamma:

  gamma

- omega:

  omega

- python_path:

  specify specific path to python if required

- nn_network_to_use:

  type of NN network to use (kNN vs sNN)

- network_name:

  name of NN network to use

- return_gobject:

  logical. return `giotto` object (default = TRUE)

- verbose:

  verbose

- feat_type:

  feature type

- toplevel:

  do not use

- version:

  version of Louvain algorithm to use. One of "community" or "multinet",
  with the default being "community"

## Value

`giotto` object with new subclusters appended to cell metadata

## Details

This function performs subclustering on selected clusters. The
systematic steps are:

1.  subset Giotto object

2.  identify highly variable genes

3.  run PCA

4.  create nearest neighbouring network

5.  do clustering

## Functions

- `doLeidenSubCluster()`: Further subcluster cells using a NN-network
  and the Leiden algorithm

- `doLouvainSubCluster()`: subcluster cells using a NN-network and the
  Louvain algorithm

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

# Run some subclusterings based on "leiden_clus" annotations that already
# exist in the visium mini object

# default method is leiden subclustering
subClusterCells(g, cluster_column = "leiden_clus")

# use louvain instead
subClusterCells(g,
    cluster_column = "leiden_clus",
    cluster_method = "louvain_community"
)

# directly call the more specific functions
doLeidenSubCluster(g, cluster_column = "leiden_clus")

doLouvainSubCluster(g, cluster_column = "leiden_clus")
```
