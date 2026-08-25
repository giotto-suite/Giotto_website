# doHclust

cluster cells using hierarchical clustering algorithm

## Usage

``` r
doHclust(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  feats_to_use = NULL,
  dim_reduction_to_use = c("cells", "pca", "umap", "tsne"),
  dim_reduction_name = "pca",
  dimensions_to_use = 1:10,
  distance_method = c("pearson", "spearman", "original", "euclidean", "maximum",
    "manhattan", "canberra", "binary", "minkowski"),
  agglomeration_method = c("ward.D2", "ward.D", "single", "complete", "average",
    "mcquitty", "median", "centroid"),
  k = 10,
  h = NULL,
  name = "hclust",
  return_gobject = TRUE,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- expression_values:

  expression values to use

- feats_to_use:

  subset of features to use

- dim_reduction_to_use:

  dimension reduction to use

- dim_reduction_name:

  dimensions reduction name

- dimensions_to_use:

  dimensions to use

- distance_method:

  distance method

- agglomeration_method:

  agglomeration method for hclust

- k:

  number of final clusters

- h:

  cut hierarchical tree at height = h

- name:

  name for hierarchical clustering

- return_gobject:

  boolean: return giotto object (default = TRUE)

- set_seed:

  set seed

- seed_number:

  number for seed

## Value

giotto object with new clusters appended to cell metadata

## Details

Description on how to use Kmeans clustering method.

## See also

[`hclust`](https://rdrr.io/r/stats/hclust.html)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

doHclust(g)
```
