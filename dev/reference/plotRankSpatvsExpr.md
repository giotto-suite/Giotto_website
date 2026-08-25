# plotRankSpatvsExpr

Plots dotplot to compare ligand-receptor rankings from spatial and
expression information

## Usage

``` r
plotRankSpatvsExpr(
  gobject,
  combCC,
  expr_rnk_column = "LR_expr_rnk",
  spat_rnk_column = "LR_spat_rnk",
  dot_color_gradient = NULL,
  midpoint = deprecated(),
  gradient_midpoint = 10,
  gradient_style = c("divergent", "sequential"),
  size_range = c(0.01, 1.5),
  xlims = NULL,
  ylims = NULL,
  selected_ranks = c(1, 10, 20),
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotRankSpatvsExpr"
)
```

## Arguments

- gobject:

  giotto object

- combCC:

  combined communication scores from
  [`combCCcom`](https://giottosuite.com/dev/reference/combCCcom.md)

- expr_rnk_column:

  column with expression rank information to use

- spat_rnk_column:

  column with spatial rank information to use

- dot_color_gradient:

  character. continuous colors to use. palette to use or vector of
  colors to use (minimum of 2).

- midpoint:

  deprecated

- gradient_midpoint:

  numeric. default = 10. midpoint of colors

- gradient_style:

  either 'divergent' (midpoint is used in color scaling) or 'sequential'
  (scaled based on data range)

- size_range:

  size ranges of dotplot

- xlims:

  x-limits, numerical vector of 2

- ylims:

  y-limits, numerical vector of 2

- selected_ranks:

  numerical vector, will be used to print out the percentage of top
  spatial ranks are recovered

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

## Value

ggplot

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

exprCC <- exprCellCellcom(g,
    cluster_column = "leiden_clus",
    feat_set_1 = "Gm19935", feat_set_2 = "9630013A20Rik"
)
spatialCC <- spatCellCellcom(
    gobject = g, cluster_column = "leiden_clus",
    feat_set_1 = "Gm19935", feat_set_2 = "9630013A20Rik", verbose = "a lot",
    random_iter = 10
)

combCC <- combCCcom(spatialCC = spatialCC, exprCC = exprCC)

plotRankSpatvsExpr(gobject = g, combCC = combCC)
```
