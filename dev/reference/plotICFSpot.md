# plotICFSpot

Create barplot to visualize interaction changed features

## Usage

``` r
plotICFSpot(
  gobject,
  icfObject,
  source_type,
  source_markers,
  ICF_features,
  cell_color_code = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotICFSpot"
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

- ICF_features:

  named character vector of ICF features

- cell_color_code:

  cell color code for the interacting cell types

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

plotICFSpot(
    gobject = g, icfObject = icfObject,
    source_type = "1", source_markers = "Ccnd2",
    ICF_features = c("3" = "Gna12", "1" = "Ccnd2", "8" = "Btbd17")
)
```
