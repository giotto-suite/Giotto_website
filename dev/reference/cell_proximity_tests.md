# Interaction changed features test methods

Perform specified test on subsets of a matrix

## Usage

``` r
.do_ttest(
  expr_values,
  select_ind,
  other_ind,
  adjust_method,
  mean_method,
  offset = 0.1
)

.do_limmatest(expr_values, select_ind, other_ind, mean_method, offset = 0.1)

.do_wilctest(
  expr_values,
  select_ind,
  other_ind,
  adjust_method,
  mean_method,
  offset = 0.1
)

.do_permuttest(
  expr_values,
  select_ind,
  other_ind,
  n_perm = 1000,
  adjust_method = "fdr",
  mean_method,
  offset = 0.1,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Value

cell proximity values

## Functions

- `.do_ttest()`: t.test

- `.do_limmatest()`: limma t.test

- `.do_wilctest()`: wilcoxon

- `.do_permuttest()`: random permutation
