# Louvain Clustering

Cluster cells using a NN-network and the Louvain algorithm. This
utilizes the generalized Louvain implementation from multinet.

## params

|  |  |
|----|----|
| `gamma` | numeric (default = 1). Resolution parameter for modularity in the generalized louvain method, |
| `omega` | numeric (default = 1). Inter-layer weight parameter in the generalized louvain method |

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
clusterData(g, clusterParam("louvain_multinet"))
```
