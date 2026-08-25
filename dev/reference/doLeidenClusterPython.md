# doLeidenClusterPython

cluster cells using a NN-network and the Leiden community detection
algorithm

## Usage

``` r
doLeidenClusterPython(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  name = "leiden_clus",
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  python_path = NULL,
  resolution = 1,
  weight_col = "weight",
  partition_type = c("RBConfigurationVertexPartition", "ModularityVertexPartition"),
  init_membership = NULL,
  n_iterations = 1000,
  return_gobject = TRUE,
  set_seed = TRUE,
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

  name for cluster, default to "leiden_clus"

- nn_network_to_use:

  type of NN network to use (kNN vs sNN), default to "sNN"

- network_name:

  name of NN network to use, default to "sNN.pca"

- python_path:

  deprecated.

- resolution:

  resolution, default = 1

- weight_col:

  weight column to use for edges, default to "weight"

- partition_type:

  The type of partition to use for optimization. (e.g.
  "RBConfigurationVertexPartition", "ModularityVertexPartition")

- init_membership:

  initial membership of cells for the partition

- n_iterations:

  number of interactions to run the Leiden algorithm. If the number of
  iterations is negative, the Leiden algorithm is run until an iteration
  in which there was no improvement.

- return_gobject:

  logical. return giotto object (default = TRUE)

- set_seed:

  set seed

- seed_number:

  number for seed

## Value

giotto object with new clusters appended to cell metadata

## Details

This function is a wrapper for the Leiden algorithm implemented in
python, which can detect communities in graphs of millions of nodes
(cells), as long as they can fit in memory. See the
[leidenalg](https://github.com/vtraag/leidenalg) github page or the
[readthedocs](https://leidenalg.readthedocs.io/en/stable/index.html)
page for more information.

Partition types available and information:

- **RBConfigurationVertexPartition:** Implements Reichardt and
  Bornholdt’s Potts model with a configuration null model. This quality
  function is well-defined only for positive edge weights. This quality
  function uses a linear resolution parameter.

- **ModularityVertexPartition:** Implements modularity. This quality
  function is well-defined only for positive edge weights. It does *not*
  use the resolution parameter

Set *weight_col = NULL* to give equal weight (=1) to each edge.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

doLeidenClusterPython(g)
```
