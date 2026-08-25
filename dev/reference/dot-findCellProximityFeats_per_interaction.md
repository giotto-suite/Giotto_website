# Find cell proximity features per interaction

Identifies features that are differentially expressed due to proximity
to other cell types.

## Usage

``` r
.findCellProximityFeats_per_interaction(
  sel_int,
  expr_values,
  cell_metadata,
  annot_spatnetwork,
  cluster_column = NULL,
  minimum_unique_cells = 1,
  minimum_unique_int_cells = 1,
  exclude_selected_cells_from_test = TRUE,
  diff_test = c("permutation", "limma", "t.test", "wilcox"),
  mean_method = c("arithmic", "geometric"),
  offset = 0.1,
  adjust_method = "bonferroni",
  nr_permutations = 100,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Arguments

- expr_values:

  Matrix object

## Value

data.table

## See also

\[.do_cell_proximity_test()\] for specific tests
