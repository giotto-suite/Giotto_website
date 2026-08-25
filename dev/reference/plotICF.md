# Plot interaction changed features

Create barplot to visualize interaction changed features

## Usage

``` r
plotICF(
  gobject,
  icfObject,
  source_type,
  source_markers,
  ICF_feats,
  cell_color_code = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotICF"
)
```

## Arguments

- gobject:

  giotto object

- icfObject:

  ICF (interaction changed feature) score object

- source_type:

  cell type of the source cell

- source_markers:

  markers for the source cell type

- ICF_feats:

  named character vector of ICF features

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

plotICF(
    gobject = g, icfObject = icfObject,
    source_type = "1", source_markers = "Ccnd2",
    ICF_feats = c("3" = "Gna12", "1" = "Ccnd2", "8" = "Btbd17")
)
```
