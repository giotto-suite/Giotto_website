# Spot permutation testing

Test spot interactions using permutations

## Usage

``` r
.do_permuttest_original_spot(
  sel_int,
  other_ints,
  select_ind,
  other_ind,
  name = "orig",
  proximityMat,
  expr_residual
)

.do_permuttest_random_spot(
  sel_int,
  other_ints,
  select_ind,
  other_ind,
  name = "perm_1",
  proximityMat,
  expr_residual,
  set_seed = TRUE,
  seed_number = 1234
)

.do_multi_permuttest_random_spot(
  sel_int,
  other_ints,
  select_ind,
  other_ind,
  proximityMat,
  expr_residual,
  n = 100,
  cores = NA,
  set_seed = TRUE,
  seed_number = 1234
)

.do_permuttest_spot(
  sel_int,
  other_ints,
  select_ind,
  other_ind,
  proximityMat,
  expr_residual,
  n_perm = 100,
  adjust_method = "fdr",
  cores = 2,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Value

data.table

## Functions

- `.do_permuttest_original_spot()`: Calculate original values for spots

- `.do_permuttest_random_spot()`: Calculate random values for spots

- `.do_multi_permuttest_random_spot()`: Calculate multiple random values
  for spots

- `.do_permuttest_spot()`: Performs permutation test on subsets of a
  matrix for spots
