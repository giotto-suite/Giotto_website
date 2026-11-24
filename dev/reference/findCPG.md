# deprecated

Identifies cell-to-cell Interaction Changed Features (ICF), i.e. genes
that are differentially expressed due to proximity to other cell types.

## Usage

``` r
findCPG(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`findICF`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)

  `gobject`

  :   giotto object

  `feat_type`

  :   feature type

  `spat_unit`

  :   spatial unit

  `expression_values`

  :   expression values to use

  `selected_feats`

  :   subset of selected features (optional). On a GiottoDisk-backed
      object only these features are read into memory (all features when
      `NULL`), so select them for large panels.

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

  `method`

  :   `"edgeicg"` (default): the spillover-aware, multi-scale model of
      the edgeicg package (contact, paracrine and niche scale; leaked
      transcripts from touching cells removed; niche calibrated and
      attributed). It uses raw counts and the cell polygons, and works
      on GiottoDisk-backed objects; see
      [`icfParam()`](https://giottosuite.com/dev/reference/icf_param.md).
      Arguments specific to the classic test (`expression_values`,
      `spatial_network_name`, `diff_test`, ...) are then ignored.
      `"classic"`: the original proximity test described in Details,
      kept as a baseline. It compares cells with and without a neighbour
      of the other type in a spatial network and does not model
      transcripts leaked from touching cells; it also loads the full
      expression matrix into memory.

  `param`

  :   optional
      [`icfParam()`](https://giottosuite.com/dev/reference/icf_param.md)
      object; overrides `method`.

## Value

cell-to-cell Interaction Changed Genes

## See also

[`findICF`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)
