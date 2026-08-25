# Compare cell types percent per polygon

Compare cell types percent per polygon

## Usage

``` r
compareCellAbundance(
  gobject,
  polygon_name = "selections",
  spat_unit = "cell",
  feat_type = "rna",
  cell_type_column = "leiden_clus",
  ...
)
```

## Arguments

- gobject:

  A Giotto object

- polygon_name:

  name of polygon selections

- spat_unit:

  spatial unit. Default = "cell"

- feat_type:

  feature type. Default = "rna"

- cell_type_column:

  column name within the cell metadata table to use

- ...:

  Additional parameters passed to ComplexHeatmap::Heatmap

## Value

A ComplexHeatmap::Heatmap

## Examples

``` r
## Plot interactive polygons
g <- GiottoData::loadGiottoMini("visium")
my_polygon_coords <- data.frame(
    poly_ID = rep("polygon1", 3),
    sdimx = c(5477, 5959, 4720), sdimy = c(-4125, -2808, -5202)
)

## Add polygon coordinates to Giotto object
my_giotto_polygons <- createGiottoPolygonsFromDfr(my_polygon_coords,
    name = "selections"
)
g <- addGiottoPolygons(
    gobject = g,
    gpolygons = list(my_giotto_polygons)
)

## Add polygon cells
g <- addPolygonCells(g)

compareCellAbundance(g)
```
