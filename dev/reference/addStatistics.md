# addStatistics

Adds feature and cell statistics to the giotto object

## Usage

``` r
addStatistics(
  gobject,
  feat_type = NULL,
  spat_unit = NULL,
  stats = c("feature", "cell", "area"),
  expression_values = c("normalized", "scaled", "custom"),
  detection_threshold = 0,
  return_gobject = TRUE,
  verbose = TRUE
)
```

## Arguments

- gobject:

  giotto object

- feat_type:

  feature type

- spat_unit:

  spatial unit

- stats:

  character. What statistics to add. default = c("cell", "feature") See
  details

- expression_values:

  expression values to use

- detection_threshold:

  detection threshold to consider a feature detected

- return_gobject:

  boolean: return giotto object (default = TRUE)

- verbose:

  be verbose

## Value

giotto object if return_gobject = TRUE, else a list with results

## `stats` options

"feature" - includes
[`addFeatStatistics`](https://giottosuite.com/dev/reference/addFeatStatistics.md)
results "cell" - includes
[`addCellStatistics`](https://giottosuite.com/dev/reference/addCellStatistics.md)
results "area" - includes polygon areas

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

addStatistics(g)
```
