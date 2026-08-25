# deprecated

Identifies cell-to-cell Interaction Changed Features (ICF), i.e. genes
that are differentially expressed due to proximity to other cell types.

## Usage

``` r
findCellProximityGenes(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`findInteractionChangedFeats`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)

  `gobject`

  :   giotto object

  `feat_type`

  :   feature type

  `spat_unit`

  :   spatial unit

  `expression_values`

  :   expression values to use

  `selected_feats`

  :   subset of selected features (optional)

  `cluster_column`

  :   name of column to use for cell types

  `spatial_network_name`

  :   name of spatial network to use

  `minimum_unique_cells`

  :   minimum number of target cells required

  `minimum_unique_int_cells`

  :   minimum number of interacting cells required

  `diff_test`

  :   which differential expression test

  `mean_method`

  :   method to use to calculate the mean

  `offset`

  :   offset value to use when calculating log2 ratio

  `adjust_method`

  :   which method to adjust p-values

  `nr_permutations`

  :   number of permutations if diff_test = permutation

  `exclude_selected_cells_from_test`

  :   exclude interacting cells other cells

  `do_parallel`

  :   run calculations in parallel with mclapply

  `set_seed`

  :   set a seed for reproducibility

  `seed_number`

  :   seed number

## Value

cell-cell interaction changed genes

## See also

[`findInteractionChangedFeats`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)
