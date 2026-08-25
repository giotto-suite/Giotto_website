# plotCombineICF

Create visualization for combined (pairwise) ICF scores

## Usage

``` r
plotCombineICF(
  gobject,
  combIcfObject,
  selected_interactions = NULL,
  selected_feat_to_feat = NULL,
  detail_plot = TRUE,
  simple_plot = FALSE,
  simple_plot_facet = c("interaction", "feats"),
  facet_scales = "fixed",
  facet_ncol = length(selected_feat_to_feat),
  facet_nrow = length(selected_interactions),
  colors = c("#9932CC", "#FF8C00"),
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotCombineICF"
)
```

## Arguments

- gobject:

  giotto object

- combIcfObject:

  ICFscores, output from combineInteractionChangedFeats()

- selected_interactions:

  interactions to show

- selected_feat_to_feat:

  pairwise feature combinations to show

- detail_plot:

  show detailed info in both interacting cell types

- simple_plot:

  show a simplified plot

- simple_plot_facet:

  facet on interactions or feats with simple plot

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

g_icf <- findInteractionChangedFeats(g,
    cluster_column = "leiden_clus",
    selected_feats = c("Gna12", "Ccnd2", "Btbd17"), nr_permutations = 10
)

combIcfObject <- combineInteractionChangedFeats(g_icf)

plotCombineICF(
    gobject = g, combIcfObject = combIcfObject,
    selected_feat_to_feat = c("Btbd17--Ccnd2", "Btbd17--Gna12"),
    selected_interactions = "1--8"
)
```
