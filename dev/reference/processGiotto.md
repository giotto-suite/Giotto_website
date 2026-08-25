# processGiotto

Wrapper for the different Giotto object processing functions

## Usage

``` r
processGiotto(
  gobject,
  filter_params = list(),
  norm_params = list(),
  stat_params = list(),
  adjust_params = list(),
  verbose = TRUE
)
```

## Arguments

- gobject:

  giotto object

- filter_params:

  additional parameters to filterGiotto

- norm_params:

  additional parameters to normalizeGiotto

- stat_params:

  additional parameters to addStatistics

- adjust_params:

  additional parameters to adjustGiottoMatrix; set to NULL if not
  required

- verbose:

  be verbose (default is TRUE)

## Value

giotto object

## Details

See
[`filterGiotto`](https://giottosuite.com/dev/reference/filterGiotto.md),
[`normalizeGiotto`](https://giottosuite.com/dev/reference/normalizeGiotto.md),
[`addStatistics`](https://giottosuite.com/dev/reference/addStatistics.md),
and
[`adjustGiottoMatrix`](https://giottosuite.com/dev/reference/adjustGiottoMatrix.md).
For more information about the different parameters in each step. If you
do not provide them it will use the default values. If no adjustment is
required, adjust_params must be set to NULL

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

processGiotto(
    gobject = g,
    adjust_params = list(covariate_columns = "leiden_clus")
)
```
