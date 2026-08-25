# Select image regions by plotting interactive polygons

Plot interactive polygons on an image and retrieve the polygons
coordinates.

## Usage

``` r
plotInteractivePolygons(x, width = "auto", height = "auto", ...)
```

## Arguments

- x:

  A \`ggplot\` or \`rast\` plot object to draw polygons on

- width, height:

  An integer, defining the width/height in pixels.

- ...:

  Graphical parameters passed on to \`polygon\` or \`geom_point\`.

## Value

A \`data.table\` containing x,y coordinates from the plotted polygons.
