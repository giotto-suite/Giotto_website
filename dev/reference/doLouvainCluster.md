# doLouvainCluster

cluster cells using a NN-network and the Louvain algorithm.

## Usage

``` r
doLouvainCluster(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  version = c("igraph", "multinet"),
  name = "louvain_clus",
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  python_path = deprecated(),
  resolution = 1,
  weight_col = NULL,
  gamma = 1,
  omega = 1,
  louv_random = deprecated(),
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

- version:

  implemented version of Louvain clustering to use: \`"igraph"\`
  (\[igraph::cluster_louvain()\]) or \`"multinet"\` (generalized Louvain
  of multinet)

- name:

  name for cluster, default to "louvain_clus"

- nn_network_to_use:

  type of NN network to use (kNN vs sNN), default to "sNN"

- network_name:

  name of NN network to use, default to "sNN.pca"

- python_path:

  deprecated.

- resolution:

  \`\[igraph\]\` resolution, default = 1. Higher values give more,
  smaller clusters.

- weight_col:

  \`\[igraph\]\` edge attribute with the weights; \`NULL\` (default)
  gives every edge weight 1

- gamma:

  \`\[multinet\]\` Resolution parameter for modularity in the
  generalized louvain method, default = 1

- omega:

  \`\[multinet\]\` Inter-layer weight parameter in the generalized
  louvain method, default = 1

- louv_random:

  deprecated: igraph's Louvain visits the vertices in a random order;
  use \`set_seed\` and \`seed_number\`.

- return_gobject:

  boolean: return giotto object (default = TRUE)

- set_seed:

  set seed (default = TRUE)

- seed_number:

  number for seed

- ...:

  not used

## Value

giotto object with new clusters appended to cell metadata

## Details

Louvain clustering using the igraph or multinet implementation of the
louvain clustering algorithm. See \[LouvainIgraphClusParam-class\] and
\[LouvainMultinetClusParam-class\] for the \[clusterData()\] params they
use.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

doLouvainCluster(g)
```
