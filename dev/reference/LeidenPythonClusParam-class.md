# Leiden Clustering

Cluster cells using a NN-network and the Leiden community detection
algorithm This version is implemented via the python package leidenalg.

## Details

This implementation is a wrapper for the Leiden algorithm implemented in
python, which can detect communities in graphs of millions of nodes
(cells), as long as they can fit in memory. See the
[leidenalg](https://github.com/vtraag/leidenalg) github page or the
[readthedocs](https://leidenalg.readthedocs.io/en/stable/index.html)
page for more information.

## params

|  |  |
|----|----|
| `resolution` | numeric (default = 1). Clustering resolution. |
| `n_iterations` | numeric (default = 20). Number of iterations to run the Leiden algorithm. If the number of iterations is negative, the Leiden algorithm is run until an iteration in which there was no improvement. |
| `weight_col` | character. (default = `weight`). Weight column in network information to use for edge weights. |
| `partition_type` | character (default = `"RBConfigurationVertexPartition"`). The type of partition to use for optimization. (one of `"RBConfigurationVertexPartition"` or `"ModularityVertexPartition"`) |
| `initial_membership` | (default = `NULL`) initial membership of cells for the partition |

## partition types available and information

- **RBConfigurationVertexPartition:** Implements Reichardt and
  Bornholdt’s Potts model with a configuration null model. This quality
  function is well-defined only for positive edge weights. This quality
  function uses a linear resolution parameter.

- **ModularityVertexPartition:** Implements modularity. This quality
  function is well-defined only for positive edge weights. It does *not*
  use the resolution parameter

Set `weight_col = NULL` to give equal weight (=1) to each edge.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
clusterData(g, clusterParam("leiden_python", resolution = 0.5))
```
