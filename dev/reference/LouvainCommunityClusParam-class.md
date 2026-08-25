# Louvain Clustering

Cluster cells using a NN-network and the Louvain algorithm. This
utilizes the {community} package from python.

## params

|  |  |
|----|----|
| `resolution` | numeric (default = 1). Clustering resolution. |
| `weight_col` | character (default = `NULL`). Weight column name. |
| `louv_random` | (default = `FALSE`) Will randomize the node evaluation order and the community evaluation order to get different partitions at each call |

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
clusterData(g, clusterParam("louvain_community", resolution = 0.5))
```
