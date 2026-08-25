# findScranMarkers

Identify marker genes for all or selected clusters based on scran's
implementation of findMarkers.

## Usage

``` r
findScranMarkers(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column,
  subset_clusters = NULL,
  group_1 = NULL,
  group_1_name = NULL,
  group_2 = NULL,
  group_2_name = NULL,
  verbose = TRUE,
  ...
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

  gene expression values to use

- cluster_column:

  clusters to use

- subset_clusters:

  selection of clusters to compare

- group_1:

  group 1 cluster IDs from cluster_column for pairwise comparison

- group_1_name:

  custom name for group_1 clusters

- group_2:

  group 2 cluster IDs from cluster_column for pairwise comparison

- group_2_name:

  custom name for group_2 clusters

- verbose:

  be verbose (default = FALSE)

- ...:

  additional parameters for the findMarkers function in scran

## Value

data.table with marker genes

## Details

This is a minimal convenience wrapper around the
[`findMarkers`](https://rdrr.io/pkg/scran/man/findMarkers.html) function
from the scran package.

To perform differential expression between custom selected groups of
cells you need to specify the cell_ID column to parameter
*cluster_column* and provide the individual cell IDs to the parameters
*group_1* and *group_2*

By default group names will be created by pasting the different id names
within each selected group. When you have many different ids in a single
group it is recommend to provide names for both groups to *group_1_name*
and *group_2_name*

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

findScranMarkers(g, cluster_column = "leiden_clus")
```
