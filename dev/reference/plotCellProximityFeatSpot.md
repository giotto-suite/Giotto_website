# plotCellProximityFeatSpot

Create visualization for cell proximity feature scores

## Usage

``` r
plotCellProximityFeatSpot(
  gobject,
  icfObject,
  method = c("volcano", "cell_barplot", "cell-cell", "cell_sankey", "heatmap", "dotplot"),
  min_cells = 4,
  min_cells_expr_resi = 0.05,
  min_int_cells = 4,
  min_int_cells_expr_resi = 0.05,
  min_fdr = 0.5,
  min_pcc_diff = 0.05,
  min_zscore = 0.05,
  zscores_column = c("cell_type", "features"),
  direction = c("both", "up", "down"),
  cell_color_code = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotCellProximityFeats"
)
```

## Arguments

- gobject:

  giotto object

- icfObject:

  ICF (interaction changed feature) score object

- method:

  plotting method to use

- min_cells:

  minimum number of source cell type

- min_cells_expr_resi:

  Default = 0.05

- min_int_cells:

  minimum number of interacting neighbor cell type

- min_int_cells_expr_resi:

  Default = 0.05

- min_fdr:

  minimum adjusted p-value

- min_pcc_diff:

  Default = 0.05

- min_zscore:

  minimum z-score change

- zscores_column:

  calculate z-scores over cell types or features

- direction:

  differential expression directions to keep

- cell_color_code:

  vector of colors with cell types as names

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

plot

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
icfObject <- findInteractionChangedFeats(g, cluster_column = "leiden_clus")

plotCellProximityFeatSpot(
    gobject = g, icfObject = icfObject,
    show_plot = TRUE, save_plot = FALSE, return_plot = FALSE,
    min_pcc_diff = 0.01
)
```
