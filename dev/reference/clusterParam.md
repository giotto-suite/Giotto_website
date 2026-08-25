# Clustering Parameter Classes

Factory function for creating param classes extending
[bluster::BlusterParam](https://rdrr.io/pkg/bluster/man/BlusterParam-class.html)
to be used with
[`clusterData()`](https://giottosuite.com/dev/reference/clusterData.md).
These param classes define the clustering operation to be performed and
also contain relevant parameters in an easily accessible format.

## Usage

``` r
clusterParam(method, ...)
```

## Arguments

- method:

  character. Parameter class to generate

- ...:

  additional params to pass to the param class creator.

## bluster params (works on matrix-like data)

- [`"kmeans"`](https://rdrr.io/pkg/bluster/man/KmeansParam-class.html) -
  K-means clustering

- [`"affinity"`](https://rdrr.io/pkg/bluster/man/AffinityParam-class.html) -
  Affinity propagation (needs apcluster)

- [`"som"`](https://rdrr.io/pkg/bluster/man/SomParam-class.html) -
  Self-organizing maps (needs kohonen)

- [`"agnes"`](https://rdrr.io/pkg/bluster/man/AgnesParam-class.html) -
  Agglomerative nesting

- [`"diana"`](https://rdrr.io/pkg/bluster/man/DianaParam-class.html) -
  Divisive analysis clustering

- [`"hclust"`](https://rdrr.io/pkg/bluster/man/HclustParam-class.html) -
  Hierarchical clustering

- [`"dbscan"`](https://rdrr.io/pkg/bluster/man/DbscanParam-class.html) -
  Density-based clustering with DBSCAN

- [`"dmm"`](https://rdrr.io/pkg/bluster/man/DmmParam-class.html) -
  Dirichlet multinomial mixture clustering (needs DirichletMultinomial)

- [`"twostep"`](https://rdrr.io/pkg/bluster/man/TwoStepParam-class.html) -
  Two step clustering with vector quantization

- [`"clara"`](https://rdrr.io/pkg/bluster/man/ClaraParam-class.html) -
  Clustering large applications (pam for large datasets)

- [`"mbkmeans"`](https://rdrr.io/pkg/bluster/man/MbkmeansParam-class.html) -
  Mini-batch k-means clustering (needs mbkmeans)

- [`"pam"`](https://rdrr.io/pkg/bluster/man/PamParam-class.html) -
  Partitioning around medoids

## giotto-specific (works on networks)

- [`"leiden_igraph"`](https://giottosuite.com/dev/reference/LeidenIgraphClusParam-class.md) -
  Leiden clustering via igraph

- [`"leiden_python"`](https://giottosuite.com/dev/reference/LeidenPythonClusParam-class.md) -
  Leiden clustering with python leidenalg

- [`"louvain_community"`](https://giottosuite.com/dev/reference/LouvainCommunityClusParam-class.md) -
  Louvain clustering with python community

- [`"louvain_multinet"`](https://giottosuite.com/dev/reference/LouvainMultinetClusParam-class.md) -
  generalized Louvain clustering with multinet

## See also

[`clusterData()`](https://giottosuite.com/dev/reference/clusterData.md)

## Examples

``` r
x <- clusterParam("kmeans", centers = 2)
x@centers

m <- matrix(runif(9), nrow = 3)
clusterData(m, x)
# add ids
rownames(m) <- paste("id", seq_len(3), sep = "_")
clusterData(m, x)
```
