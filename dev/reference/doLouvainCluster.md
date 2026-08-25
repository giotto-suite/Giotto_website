# doLouvainCluster

cluster cells using a NN-network and the Louvain algorithm.

## Usage

``` r
doLouvainCluster(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  version = c("community", "multinet"),
  name = "louvain_clus",
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  python_path = deprecated(),
  resolution = 1,
  weight_col = NULL,
  gamma = 1,
  omega = 1,
  louv_random = FALSE,
  return_gobject = TRUE,
  set_seed = FALSE,
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

  implemented version of Louvain clustering to use

- name:

  name for cluster, default to "louvain_clus"

- nn_network_to_use:

  type of NN network to use (kNN vs sNN), default to "sNN"

- network_name:

  name of NN network to use, default to "sNN.pca"

- python_path:

  deprecated.

- resolution:

  \[community\] resolution, default = 1

- weight_col:

  weight column name

- gamma:

  \[multinet\] Resolution parameter for modularity in the generalized
  louvain method, default = 1

- omega:

  \[multinet\] Inter-layer weight parameter in the generalized louvain
  method, default = 1

- louv_random:

  \[community\] Will randomize the node evaluation order and the
  community evaluation order to get different partitions at each call
  (default = FALSE)

- return_gobject:

  boolean: return giotto object (default = TRUE)

- set_seed:

  set seed (default = FALSE)

- seed_number:

  number for seed

- ...:

  arguments passed to
  [`.doLouvainCluster_community`](https://giottosuite.com/dev/reference/dot-doLouvainCluster_community.md)

## Value

giotto object with new clusters appended to cell metadata

## Details

Louvain clustering using the community or multinet implementation of the
louvain clustering algorithm.

## See also

[`.doLouvainCluster_community`](https://giottosuite.com/dev/reference/dot-doLouvainCluster_community.md)
and
[`.doLouvainCluster_multinet`](https://giottosuite.com/dev/reference/dot-doLouvainCluster_multinet.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

doLouvainCluster(g)
```
