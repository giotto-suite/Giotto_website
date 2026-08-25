# Add corresponding polygon IDs to cell metadata

Add corresponding polygon IDs to cell metadata

## Usage

``` r
addPolygonCells(
  gobject,
  polygon_name = "selections",
  spat_unit = "cell",
  spat_loc_name = "raw",
  feat_type = "rna",
  polygons = NULL,
  na.label = "no_polygon"
)
```

## Arguments

- gobject:

  A Giotto object

- polygon_name:

  name of polygon selections

- spat_unit:

  spatial unit

- spat_loc_name:

  name of spatial locations to use

- feat_type:

  feature name where metadata will be added

- polygons:

  polygon names to plot (e.g. 'polygon_1'). If NULL, plots all available
  polygons

- na.label:

  polygon label for cells located outside of polygons area. Default =
  "no_polygon"

## Value

A Giotto object with a modified cell_metadata slot that includes the
polygon name where each cell is located or no_polygon label if the cell
is not located within a polygon area

## Examples

``` r
## Plot interactive polygons
g <- GiottoData::loadGiottoMini("visium")
my_polygon_coords <- data.frame(
    poly_ID = rep("polygon1", 3),
    sdimx = c(5477, 5959, 4720),
    sdimy = c(-4125, -2808, -5202)
)

## Add polygon coordinates to Giotto object
my_giotto_polygons <- createGiottoPolygon(
    my_polygon_coords,
    name = "selections"
)

g <- addGiottoPolygons(
    gobject = g,
    gpolygons = list(my_giotto_polygons)
)

## Add polygon IDs to cell metadata
g <- addPolygonCells(g)
pDataDT(g)
```
