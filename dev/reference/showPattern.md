# showPattern

show patterns for 2D spatial data

## Usage

``` r
showPattern(gobject, spatPatObj, ...)
```

## Arguments

- gobject:

  giotto object

- spatPatObj:

  Output from detectSpatialPatterns

- ...:

  Arguments passed on to
  [`showPattern2D`](https://giottosuite.com/dev/reference/showPattern2D.md)

  `dimension`

  :   dimension to plot

  `trim`

  :   Trim ends of the PC values.

  `background_color`

  :   background color for plot

  `grid_border_color`

  :   color for grid

  `show_legend`

  :   show legend of ggplot

  `point_size`

  :   size of points

  `show_plot`

  :   show plot

  `return_plot`

  :   return ggplot object

  `save_plot`

  :   directly save the plot \[boolean\]

  `save_param`

  :   list of saving parameters, see
      [`showSaveParameters`](https://giotto-suite.github.io/GiottoVisuals/reference/showSaveParameters.html)

  `default_save_name`

  :   default save name for saving, don't change, change save_name in
      save_param

## Value

ggplot

## See also

[`showPattern2D`](https://giottosuite.com/dev/reference/showPattern2D.md)
