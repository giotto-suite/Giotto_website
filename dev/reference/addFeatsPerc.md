# addFeatsPerc

Calculates the total percentage of (normalized) counts for a subset of
selected genes

## Usage

``` r
addFeatsPerc(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  feats = NULL,
  vector_name = "feat_perc",
  return_gobject = TRUE
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- expression_values:

  expression values to use

- feats:

  vector of selected features

- vector_name:

  column name as seen in
  [`pDataDT`](https://giotto-suite.github.io/GiottoClass/reference/pDataDT.html)

- return_gobject:

  boolean: return giotto object (default = TRUE)

## Value

giotto object if `return_gobject = TRUE`, else a vector with results

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

addFeatsPerc(g, feats = c("Gm19935", "9630013A20Rik", "2900040C04Rik"))
```
