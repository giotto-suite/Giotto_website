# doRandomWalkCluster

Cluster cells using a random walk approach.

## Usage

``` r
doRandomWalkCluster(
  gobject,
  name = "random_walk_clus",
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  walk_steps = 4,
  walk_clusters = 10,
  walk_weights = NA,
  return_gobject = TRUE,
  set_seed = FALSE,
  seed_number = 1234
)
```

## Arguments

- gobject:

  giotto object

- name:

  name for cluster, default to "random_walk_clus"

- nn_network_to_use:

  type of NN network to use (kNN vs sNN), default to "sNN"

- network_name:

  name of NN network to use, default to "sNN.pca"

- walk_steps:

  number of walking steps, default = 4

- walk_clusters:

  number of final clusters, default = 10

- walk_weights:

  cluster column defining the walk weights

- return_gobject:

  boolean: return giotto object (default = TRUE)

- set_seed:

  set seed (default = FALSE)

- seed_number:

  number for seed

## Value

giotto object with new clusters appended to cell metadata

## Details

See
[`cluster_walktrap`](https://r.igraph.org/reference/cluster_walktrap.html)
function from the igraph package in R for more information.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

g <- doRandomWalkCluster(g)
pDataDT(g)
```
