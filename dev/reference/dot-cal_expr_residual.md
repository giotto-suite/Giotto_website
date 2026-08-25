# Calculate feature expression residual

Calculate feature expression residual (observed_exp - DWLS_predicted)

## Usage

``` r
.cal_expr_residual(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  ave_celltype_exp
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. 'cell')

- feat_type:

  feature type (e.g. 'rna')

- expression_values:

  expression values to use (e.g. 'normalized', 'scaled', 'custom')

- ave_celltype_exp:

  average expression matrix in cell types

## Value

matrix
