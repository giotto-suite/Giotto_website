# Leiden Clustering

Cluster cells using a NN-network and the Leiden community detection
algorithm as implemented in igraph.

## Details

This function is a wrapper for the Leiden algorithm implemented in
igraph, which can detect communities in graphs of millions of nodes
(cells), as long as they can fit in memory. See
[`cluster_leiden`](https://r.igraph.org/reference/cluster_leiden.html)
for more information.

## params

|  |  |
|----|----|
| `resolution` | numeric (default = 1). Clustering resolution. |
| `n_iterations` | numeric (default = 20). Number of iterations to run the Leiden algorithm. |
| `weights` | (default = `NULL`) weights of edges. Set `NULL` to use weights associated with the igraph network. Set `NA` if you don't want to use weights. |
| `beta` | character (default = 0.01). Leiden randomness |
| `objective_function` | character (default = `"modularity"`) objective function for the leiden algorithm. One of `"modularity"` or `"CPM"` |
| `initial_membership` | (default = `NULL`) initial membership of cells for the partition. |

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
clusterData(g, clusterParam("leiden_igraph", resolution = 0.5))
```
