# Find ICF per interaction for spot data

Identifies features that are differentially expressed due to proximity
to other cell types for spots.

## Usage

``` r
.findICF_per_interaction_spot(
  sel_int,
  all_ints,
  proximityMat,
  expr_residual,
  dwls_values,
  dwls_cutoff = 0.001,
  CCI_cell_score = 0.01,
  minimum_unique_cells = 1,
  minimum_unique_int_cells = 1,
  diff_test = "permutation",
  n_perm = 100,
  adjust_method = "fdr",
  cores = 2,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Value

data.table
