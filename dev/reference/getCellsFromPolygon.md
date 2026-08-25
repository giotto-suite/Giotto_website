# Get cells located within the polygons area

Get cells located within the polygons area

## Usage

``` r
getCellsFromPolygon(
  gobject,
  polygon_name = "selections",
  spat_unit = "cell",
  spat_loc_name = "raw",
  polygons = NULL
)
```

## Arguments

- gobject:

  A Giotto object

- polygon_name:

  name of polygon selections

- spat_unit:

  spatial unit, default = 'cell'

- spat_loc_name:

  name of spatial locations to use, default = 'raw'

- polygons:

  character. A vector with polygon names to extract cells from. If NULL,
  cells from all polygons are retrieved

## Value

A terra 'SpatVector' with cell ID, x y coordinates, and polygon ID where
each cell is located in.

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

## Add polygon IDs to cell metadata
addPolygonCells(g)

## Get only cells from polygon 1
getCellsFromPolygon(g)
```
