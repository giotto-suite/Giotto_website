# viewHMRFresults_V2

function to view HMRF results with multiple betas

## Usage

``` r
viewHMRFresults_V2(
  gobject,
  k,
  betas,
  hmrf_name,
  spat_unit = NULL,
  feat_type = NULL,
  third_dim = FALSE,
  cow_n_col = 2,
  cow_rel_h = 1,
  cow_rel_w = 1,
  cow_align = "h",
  show_plot = TRUE,
  save_plot = TRUE,
  return_plot = TRUE,
  default_save_name = "HMRF_result",
  save_param = list(),
  ...
)
```

## Arguments

- gobject:

  giotto object

- k:

  number of clusters in hmrf results

- betas:

  values of beta to plot

- hmrf_name:

  name of hmrf models

- spat_unit:

  spatial unit

- feat_type:

  feature type

- third_dim:

  index of 3D plot

- cow_n_col:

  number of columns to show in figure

- cow_rel_h:

  relative height

- cow_rel_w:

  relative width

- cow_align:

  cowplot alignment parameter

- show_plot:

  option to show plot

- save_plot:

  option to save plot

- return_plot:

  if function return a plot

- default_save_name:

  names of figure file to save

- save_param:

  other saving parameters

- ...:

  additional params to pass to plotting

## Value

spatial plots with HMRF domains

## Details

This function plots spatial map of HMRF domain clusters for multiple
beta with the name (hmrf_name), matching the first part of the cell meta
column names with HMRF clusters (for example name of ‘hmrf1 k=8 b=0.00’
is ‘hmrf1’)
