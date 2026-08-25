# doKmeans

cluster cells using kmeans algorithm

## Usage

``` r
doKmeans(
  gobject,
  feat_type = NULL,
  spat_unit = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  feats_to_use = NULL,
  dim_reduction_to_use = c("cells", "pca", "umap", "tsne"),
  dim_reduction_name = "pca",
  dimensions_to_use = 1:10,
  distance_method = c("original", "pearson", "spearman", "euclidean", "maximum",
    "manhattan", "canberra", "binary", "minkowski"),
  centers = 10,
  iter_max = 100,
  nstart = 1000,
  algorithm = "Hartigan-Wong",
  name = "kmeans",
  return_gobject = TRUE,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Arguments

- gobject:

  giotto object

- feat_type:

  feature type (e.g. "cell")

- spat_unit:

  spatial unit (e.g. "rna", "dna", "protein")

- expression_values:

  expression values from list_expression() (e.g. "normalized", "scaled",
  "custom")

- feats_to_use:

  (optional) subset of features to use

- dim_reduction_to_use:

  dimension reduction from list_dim_reductions() (e.g. "pca", "umap",
  "tsne")

- dim_reduction_name:

  dimensions reduction name, default to "pca"

- dimensions_to_use:

  dimensions to use, default = 1:10

- distance_method:

  distance method (e.g. "original", "pearson", "spearman", "euclidean",
  "maximum", "manhattan", "canberra", "binary", "minkowski")

- centers:

  number of final clusters, default = 10

- iter_max:

  kmeans maximum iterations, default = 100

- nstart:

  kmeans nstart, default = 1000

- algorithm:

  kmeans algorithm, default to "Hartigan-Wong"

- name:

  name for kmeans clustering, default to "kmeans"

- return_gobject:

  boolean: return giotto object (default = TRUE)

- set_seed:

  set seed (default = TRUE)

- seed_number:

  number for seed

## Value

if return_gobject = TRUE: giotto object with new clusters appended to
cell metadata

## Details

The default settings will use dimension reduction results as input. Set
dim_reduction_to_use = NULL if you want to directly use expression
values as input. By providing a feature vector to feats_to_use you can
subset the expression matrix.

## See also

[`kmeans`](https://rdrr.io/r/stats/kmeans.html)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

doKmeans(g)
```
