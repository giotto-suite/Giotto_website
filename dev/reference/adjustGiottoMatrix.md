# Adjust expression values

Adjust expression values to account for known batch effects or
technological covariates.

## Usage

``` r
adjustGiottoMatrix(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  batch_columns = NULL,
  covariate_columns = NULL,
  name = "custom",
  return_gobject = TRUE,
  update_slot = deprecated()
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- expression_values:

  expression values to use

- batch_columns:

  metadata columns that represent different batch (max = 2)

- covariate_columns:

  metadata columns that represent covariates to regress out

- name:

  character. Name to assign to adjusted matrix (default = "custom")

- return_gobject:

  boolean: return giotto object (default = TRUE)

- update_slot:

  deprecated.

## Value

giotto object or exprObj

## Details

This function implements the
[`removeBatchEffect`](https://rdrr.io/pkg/limma/man/removeBatchEffect.html)
function to remove known batch effects and to adjust expression values
according to provided covariates.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

adjustGiottoMatrix(g, covariate_columns = "leiden_clus")
```
