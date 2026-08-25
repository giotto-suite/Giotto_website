# plotCTCompositionInNicheCluster

plot cell type composition within each niche cluster

## Usage

``` r
plotCTCompositionInNicheCluster(
  gobject,
  cell_type,
  values = "prob",
  spat_unit = "cell",
  feat_type = "niche cluster",
  normalization = c("by_niche_cluster", "by_cell_type", NULL),
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "CellTypeCompositionInNicheCluster"
)
```

## Arguments

- gobject:

  giotto object

- cell_type:

  the cell type column name in the metadata

- values:

  name of the expression matrix stored probability of each cell assigned
  to each niche cluster

- spat_unit:

  name of spatial unit niche stored cluster features

- feat_type:

  name of the feature type stored probability matrix

- normalization:

  normalization method for the cell type composition

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

## Details

This function plots the cell type composition within each niche cluster
