# Heatmap of spatial co-expression modules

Correlation heatmap of the features grouped by
\[spatialCoexpression()\], ordered by its clustering and annotated by
module.

## Usage

``` r
heatmapCoexpression(
  gobject,
  coexpression,
  show_row_names = FALSE,
  show_column_names = FALSE,
  show_row_dend = TRUE,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "heatmapCoexpression",
  ...
)
```

## Arguments

- gobject:

  giotto object, for the plot instructions

- coexpression:

  the list returned by \`spatialCoexpression(return_gobject = FALSE)\`

- show_row_names, show_column_names:

  show feature names

- show_row_dend:

  show the row dendrogram

- show_plot:

  logical. show plot

- return_plot:

  logical. return ggplot object

- save_plot:

  logical. save the plot

- save_param:

  list of saving parameters, see
  [`showSaveParameters`](https://giotto-suite.github.io/GiottoVisuals/reference/showSaveParameters.html)

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

- ...:

  additional arguments to \[ComplexHeatmap::Heatmap()\]

## Value

a ComplexHeatmap heatmap, depending on the plot settings
