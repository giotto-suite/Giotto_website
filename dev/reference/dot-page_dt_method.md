# PAGE data.table method

PAGE data.table method

## Usage

``` r
.page_dt_method(
  sign_matrix,
  expr_values,
  min_overlap_genes = 5,
  logbase = 2,
  reverse_log_scale = TRUE,
  output_enrichment = c("original", "zscore"),
  p_value = FALSE,
  include_depletion = FALSE,
  n_times = 1000,
  max_block = 2e+07,
  verbose = TRUE
)
```

## Arguments

- expr_values:

  matrix of expression values

## Value

data.table
