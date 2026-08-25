# plotSpatNicheClusterBin

plot spatial niche cluster binarized

## Usage

``` r
plotSpatNicheClusterBin(
  gobject,
  spat_unit = "cell",
  feat_type = "niche cluster",
  ...,
  default_save_name = "spatNicheClusterBin"
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  name of spatial unit niche stored cluster features

- feat_type:

  name of the feature type stored binarized niche cluster

- ...:

  additional arguments to be passed to the spatFeatPlot2D function

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

- niche_cluster_label:

  name of the niche cluster label

## Value

ggplot

## Details

This function plots the spatial niche cluster binarized
