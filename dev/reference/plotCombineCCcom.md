# plotCombineCCcom

Create visualization for combined (pairwise) cell proximity gene scores

## Usage

``` r
plotCombineCCcom(
  gobject,
  combCCcom,
  selected_LR = NULL,
  selected_cell_LR = NULL,
  detail_plot = TRUE,
  simple_plot = FALSE,
  simple_plot_facet = c("interaction", "genes"),
  facet_scales = "fixed",
  facet_ncol = length(selected_LR),
  facet_nrow = length(selected_cell_LR),
  colors = c("#9932CC", "#FF8C00"),
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotCombineCCcom"
)
```

## Arguments

- gobject:

  giotto object

- combCCcom:

  combined communcation scores, output from combCCcom()

- selected_LR:

  selected ligand-receptor pair

- selected_cell_LR:

  selected cell-cell interaction pair for ligand-receptor pair

- detail_plot:

  show detailed info in both interacting cell types

- simple_plot:

  show a simplified plot

- simple_plot_facet:

  facet on interactions or genes with simple plot

- facet_scales:

  ggplot facet scales paramter

- facet_ncol:

  ggplot facet ncol parameter

- facet_nrow:

  ggplot facet nrow parameter

- colors:

  vector with two colors to use

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

comScores <- exprCellCellcom(g,
    cluster_column = "leiden_clus",
    feat_set_1 = c("Gm19935", "2900040C04Rik", "Ccnd2"),
    feat_set_2 = c("9630013A20Rik", "Gna12", "Btbd17")
)

exprCC <- exprCellCellcom(g,
    cluster_column = "leiden_clus",
    feat_set_1 = "Gm19935", feat_set_2 = "9630013A20Rik"
)
spatialCC <- spatCellCellcom(
    gobject = g, cluster_column = "leiden_clus",
    feat_set_1 = "Gm19935", feat_set_2 = "9630013A20Rik", verbose = "a lot"
)

combCCcom <- combCCcom(spatialCC = spatialCC, exprCC = exprCC)

plotCombineCCcom(
    gobject = g, combCCcom = combCCcom,
    selected_LR = c("Gm19935-9630013A20Rik"), selected_cell_LR = c("1--1")
)
```
