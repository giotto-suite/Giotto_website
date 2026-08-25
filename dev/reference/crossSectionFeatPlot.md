# crossSectionFeatPlot

Visualize cells and feature expression in a virtual cross section
according to spatial coordinates

## Usage

``` r
crossSectionFeatPlot(
  gobject = NULL,
  spat_unit = NULL,
  feat_type = NULL,
  spat_loc_name = "raw",
  crossSection_obj = NULL,
  name = NULL,
  spatial_network_name = "Delaunay_network",
  default_save_name = "crossSectionGenePlot",
  ...
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- spat_loc_name:

  name of spatial locations

- crossSection_obj:

  crossSection object

- name:

  name of virtual cross section to use

- spatial_network_name:

  name of spatial network to use

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

- ...:

  parameters for spatFeatPlot2D

## Value

ggplot

## Details

Description of parameters.

## See also

[GiottoVisuals::spatGenePlot3D](https://giotto-suite.github.io/GiottoVisuals/reference/spatFeatPlot3D.html)
and
[GiottoVisuals::spatFeatPlot2D](https://giotto-suite.github.io/GiottoVisuals/reference/spatFeatPlot2D.html)
