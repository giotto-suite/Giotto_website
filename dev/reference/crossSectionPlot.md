# crossSectionPlot

Visualize cells in a virtual cross section according to spatial
coordinates

## Usage

``` r
crossSectionPlot(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  spat_loc_name = "raw",
  crossSection_obj = NULL,
  name = NULL,
  spatial_network_name = "Delaunay_network",
  default_save_name = "crossSectionPlot",
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

  cross section object as alternative input. default = NULL.

- name:

  name of virtual cross section to use

- spatial_network_name:

  name of spatial network to use

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

- ...:

  parameters for spatPlot2D

## Value

ggplot

## Details

Description of parameters.

## See also

`crossSectionPlot`
