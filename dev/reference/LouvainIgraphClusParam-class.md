# Louvain Clustering

Cluster cells using a NN-network and the Louvain algorithm as
implemented in igraph
([`cluster_louvain`](https://r.igraph.org/reference/cluster_louvain.html)).
The network is made undirected first. Louvain visits the vertices in a
random order, so set a seed for reproducible clusters
(`clusterData(set_seed = TRUE)`, the default).

## params

|  |  |
|----|----|
| `resolution` | numeric (default = 1). Clustering resolution: higher values give more, smaller clusters. |
| `weights` | (default = `NULL`) edge weights: `NULL` uses the network's `weight` edge attribute, `NA` gives every edge weight 1, and a character value names another edge attribute. |

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
clusterData(g, clusterParam("louvain_igraph", resolution = 0.5))
```
