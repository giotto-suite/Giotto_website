# addCellIntMetadata

Creates an additional metadata column with information about interacting
and non-interacting cell types of the selected cell-cell interaction.

## Usage

``` r
addCellIntMetadata(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  spatial_network = "spatial_network",
  cluster_column,
  cell_interaction,
  name = "select_int",
  return_gobject = TRUE
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- spatial_network:

  name of spatial network to use

- cluster_column:

  column of cell types

- cell_interaction:

  cell-cell interaction to use

- name:

  name for the new metadata column

- return_gobject:

  return an updated giotto object

## Value

Giotto object

## Details

This function will create an additional metadata column which selects
interacting cell types for a specific cell-cell interaction. For
example, if you want to color interacting astrocytes and
oligodendrocytes it will create a new metadata column with the values
"select_astrocytes", "select_oligodendrocytes", "other_astrocytes",
"other_oligodendroyctes" and "other". Where "other" is all other cell
types found within the selected cell type column.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

addCellIntMetadata(g,
    cluster_column = "leiden_clus",
    cell_interaction = "custom_leiden"
)
```
