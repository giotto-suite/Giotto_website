# doLouvainCluster multinet

cluster cells using a NN-network and the Louvain algorithm from the
multinet package in R.

## Usage

``` r
.doLouvainCluster_multinet(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  name = "louvain_clus",
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  gamma = 1,
  omega = 1,
  return_gobject = TRUE,
  set_seed = FALSE,
  seed_number = 1234
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

  name for cluster, default to "louvain_clus"

- nn_network_to_use:

  type of NN network to use (kNN vs sNN), default to "sNN"

- network_name:

  name of NN network to use, default to "sNN.pca"

- gamma:

  Resolution parameter for modularity in the generalized louvain method.
  default = 1

- omega:

  Inter-layer weight parameter in the generalized louvain method.
  default = 1

- return_gobject:

  boolean: return giotto object (default = TRUE)

- set_seed:

  set seed (default = FALSE)

- seed_number:

  number for seed

## Value

giotto object with new clusters appended to cell metadata

## Details

See `glouvain_ml` from the multinet package in R for more information.
