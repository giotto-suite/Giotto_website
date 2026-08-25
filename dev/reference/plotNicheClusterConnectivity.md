# plotNicheClusterConnectivity

plot niche cluster connectivity

## Usage

``` r
plotNicheClusterConnectivity(
  gobject,
  spat_unit = "niche cluster",
  feat_type = "connectivity",
  values = "normalized",
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "NicheClusterConnectivity"
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  name of spatial unit niche stored cluster features

- feat_type:

  name of the feature type stored niche cluster connectivities

- values:

  name of the expression matrix stored connectivity values

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

This function plots the niche cluster connectivity matrix
