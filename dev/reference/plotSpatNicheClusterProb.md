# plotSpatNicheClusterProb

plot spatial niche cluster probability

## Usage

``` r
plotSpatNicheClusterProb(
  gobject,
  spat_unit = "cell",
  feat_type = "niche cluster",
  expression_values = "prob",
  ...,
  default_save_name = "spatNicheClusterProb"
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  name of spatial unit niche stored cluster features

- feat_type:

  name of the feature type stored probability matrix

- expression_values:

  name of the expression matrix stored probability values

- ...:

  additional arguments to be passed to the spatFeatPlot2D function

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

## Value

ggplot

## Details

This function plots the spatial niche cluster probability
