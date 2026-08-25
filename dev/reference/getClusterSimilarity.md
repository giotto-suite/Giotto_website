# getClusterSimilarity

Creates data.table with pairwise correlation scores between each
cluster.

## Usage

``` r
getClusterSimilarity(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column,
  cor = c("pearson", "spearman")
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

- cluster_column:

  name of column to use for clusters

- cor:

  correlation score to calculate distance

## Value

data.table

## Details

Creates data.table with pairwise correlation scores between each cluster
and the group size (# of cells) for each cluster. This information can
be used together with mergeClusters to combine very similar or small
clusters into bigger clusters.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

getClusterSimilarity(g, cluster_column = "leiden_clus")
```
