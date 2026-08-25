# plotRecovery

Plots recovery plot to compare ligand-receptor rankings from spatial and
expression information

## Usage

``` r
plotRecovery(
  gobject,
  combCC,
  expr_rnk_column = "exprPI_rnk",
  spat_rnk_column = "spatPI_rnk",
  ground_truth = c("spatial", "expression"),
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotRecovery"
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

- ground_truth:

  what to consider as ground truth (default: spatial)

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

plotRecovery(gobject = g, combCC = combCC)
```
