# plotCPF

Create visualization for cell proximity feature scores

## Usage

``` r
plotCPF(
  gobject,
  icfObject,
  method = c("volcano", "cell_barplot", "cell-cell", "cell_sankey", "heatmap", "dotplot"),
  min_cells = 5,
  min_cells_expr = 1,
  min_int_cells = 3,
  min_int_cells_expr = 1,
  min_fdr = 0.05,
  min_spat_diff = 0.2,
  min_log2_fc = 0.2,
  min_zscore = 2,
  zscores_column = c("cell_type", "feats"),
  direction = c("both", "up", "down"),
  cell_color_code = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotCPG"
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

- min_cells_expr:

  minimum expression level for source cell type

- min_int_cells:

  minimum number of interacting neighbor cell type

- min_int_cells_expr:

  minimum expression level for interacting neighbor cell type

- min_fdr:

  minimum adjusted p-value

- min_spat_diff:

  minimum absolute spatial expression difference

- min_log2_fc:

  minimum log2 fold-change

- min_zscore:

  minimum z-score change

- zscores_column:

  calculate z-scores over cell types or features

- direction:

  differential expression directions to keep

- cell_color_code:

  character. discrete colors to use. palette to use or named vector of
  colors

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
icfObject <- findInteractionChangedFeats(g,
    cluster_column = "leiden_clus",
    selected_feats = c("Gna12", "Ccnd2", "Btbd17"), nr_permutations = 10
)

plotCPF(
    gobject = g, icfObject = icfObject, show_plot = TRUE,
    save_plot = FALSE, return_plot = FALSE
)
```
