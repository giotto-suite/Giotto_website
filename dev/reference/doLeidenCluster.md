# doLeidenCluster

cluster cells using a NN-network and the Leiden community detection
algorithm as implemented in igraph

## Usage

``` r
doLeidenClusterIgraph(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  name = "leiden_clus",
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  objective_function = c("modularity", "CPM"),
  weights = NULL,
  resolution = 1,
  beta = 0.01,
  initial_membership = NULL,
  n_iterations = 1000,
  return_gobject = TRUE,
  set_seed = TRUE,
  seed_number = 1234,
  ...
)

doLeidenCluster(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  name = "leiden_clus",
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  objective_function = c("modularity", "CPM"),
  weights = NULL,
  resolution = 1,
  beta = 0.01,
  initial_membership = NULL,
  n_iterations = 1000,
  return_gobject = TRUE,
  set_seed = TRUE,
  seed_number = 1234,
  ...
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- name:

  name for cluster, default to "leiden_clus"

- nn_network_to_use:

  type of NN network to use (kNN vs sNN), default to "sNN"

- network_name:

  name of NN network to use, default to "sNN.pca"

- objective_function:

  objective function for the leiden algo

- weights:

  weights of edges

- resolution:

  resolution, default = 1

- beta:

  leiden randomness

- initial_membership:

  initial membership of cells for the partition

- n_iterations:

  number of interations to run the Leiden algorithm.

- return_gobject:

  boolean: return giotto object (default = TRUE)

- set_seed:

  set seed

- seed_number:

  number for seed

- ...:

  Arguments passed on to
  [`igraph::cluster_leiden`](https://r.igraph.org/reference/cluster_leiden.html)

  `resolution_parameter`

  :   **\[superseded\]** Use `resolution` instead.

  `vertex_weights`

  :   the vertex weights used in the Leiden algorithm. If this is not
      provided, it will be automatically determined on the basis of the
      `objective_function`. Please see the details of this function how
      to interpret the vertex weights.

## Value

giotto object with new clusters appended to cell metadata

## Details

This function is a wrapper for the Leiden algorithm implemented in
igraph, which can detect communities in graphs of millions of nodes
(cells), as long as they can fit in memory. See
[`cluster_leiden`](https://r.igraph.org/reference/cluster_leiden.html)
for more information.

Set *weights = NULL* to use the vertices weights associated with the
igraph network. Set *weights = NA* if you don't want to use vertices
weights

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

doLeidenCluster(g)
```
