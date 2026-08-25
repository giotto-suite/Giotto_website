# Compute spatial auto correlation using spdep

Compute spatial auto correlation using spdep

## Usage

``` r
spdepAutoCorr(
  gobject,
  method = c("geary.test", "lee.test", "lm.morantest", "moran.test"),
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = "normalized",
  spatial_network_to_use = "spatial_network",
  return_gobject = FALSE,
  verbose = FALSE
)
```

## Arguments

- gobject:

  Input a Giotto object.

- method:

  Specify a method name to compute auto correlation. Available methods
  include `"geary.test", "lee.test", "lm.morantest","moran.test"`.

- spat_unit:

  spatial unit

- feat_type:

  feature type

- expression_values:

  expression values to use, default = normalized

- spatial_network_to_use:

  spatial network to use, default = spatial_network

- return_gobject:

  if FALSE, results are returned as data.table. If TRUE, values will be
  appended to feature metadata

- verbose:

  be verbose

## Value

A data table with computed values for each feature.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

spdepAutoCorr(g)
```
