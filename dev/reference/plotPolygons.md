# Plot stored polygons

Plot stored polygons

## Usage

``` r
plotPolygons(
  gobject,
  polygon_name = "selections",
  x,
  spat_unit = "cell",
  polygons = NULL,
  ...
)
```

## Arguments

- gobject:

  A Giotto object with polygon coordinates

- polygon_name:

  name of polygon selections

- x:

  A ggplot2, spatPlot or terra::rast object

- spat_unit:

  spatial unit

- polygons:

  character. Vector of polygon names to plot. If NULL, all polygons are
  plotted

- ...:

  Additional parameters passed to ggplot2::geom_polygon() or
  graphics::polygon

## Value

A ggplot2 image

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

## Create spatplot
x <- spatPlot2D(g, return_plot = TRUE)

plotPolygons(g, x = x)
```
