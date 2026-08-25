# viewHMRFresults2D

View results from doHMRF.

## Usage

``` r
viewHMRFresults2D(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  HMRFoutput,
  k = NULL,
  betas_to_view = NULL,
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

- HMRFoutput:

  HMRF output from doHMRF

- k:

  number of HMRF domains

- betas_to_view:

  results from different betas that you want to view

- ...:

  additional parameters to spatPlot2D()

## Value

spatial plots with HMRF domains

## See also

[`spatPlot2D`](https://giotto-suite.github.io/GiottoVisuals/reference/spatPlot.html)
