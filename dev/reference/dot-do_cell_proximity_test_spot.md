# Cell proximity testing for spot data

Performs a selected differential test on subsets of a matrix for spots

## Usage

``` r
.do_cell_proximity_test_spot(
  sel_int,
  other_ints,
  select_ind,
  other_ind,
  proximityMat,
  expr_residual,
  diff_test,
  n_perm = 100,
  adjust_method = "fdr",
  cores = 2,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Value

differential test on subsets of a matrix
