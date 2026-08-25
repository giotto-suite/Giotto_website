# Find network neighbors

Find the spatial neighbors for a selected group of cells within the
selected spatial network.

## Usage

``` r
findNetworkNeighbors(
  gobject,
  spat_unit = NULL,
  spatial_network_name = NULL,
  source_cell_ids = NULL,
  name = "nb_cells"
)
```

## Arguments

- gobject:

  Giotto object

- spat_unit:

  spatial unit

- spatial_network_name:

  name of spatial network

- source_cell_ids:

  cell ids for which you want to know the spatial neighbors

- name:

  name of the results

## Value

data.table

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

findNetworkNeighbors(
    gobject = g, spatial_network_name = "spatial_network",
    source_cell_ids = c("AACTCGATGGCGCAGT-1", "GGCTGGCTAGCTTAAA-1")
)
```
