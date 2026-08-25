# Specific cell-cell communication scores for spot data

Specific Cell-Cell communication scores based on spatial expression of
interacting cells at spots resolution

## Usage

``` r
.specific_CCCScores_spots(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expr_residual,
  dwls_values,
  proximityMat,
  random_iter = 1000,
  cell_type_1 = "astrocytes",
  cell_type_2 = "endothelial",
  feature_set_1,
  feature_set_2,
  min_observations = 2,
  detailed = FALSE,
  adjust_method = c("fdr", "bonferroni", " BH", "holm", "hochberg", "hommel", "BY",
    "none"),
  adjust_target = c("features", "cells"),
  set_seed = FALSE,
  seed_number = 1234,
  verbose = FALSE
)
```

## Arguments

- gobject:

  giotto object to use

- spat_unit:

  spatial unit (e.g. 'cell')

- feat_type:

  feature type (e.g. 'rna')

- expr_residual:

  spatial network to use for identifying interacting cells

- dwls_values:

  dwls matrix

- proximityMat:

  cell cell communication score matrix

- random_iter:

  number of iterations

- cell_type_1:

  first cell type

- cell_type_2:

  second cell type

- feature_set_1:

  first specific feature set from feature pairs

- feature_set_2:

  second specific feature set from feature pairs

- min_observations:

  minimum number of interactions needed to be considered

- detailed:

  provide more detailed information (random variance and z-score)

- adjust_method:

  which method to adjust p-values

- adjust_target:

  adjust multiple hypotheses at the cell or feature level

- set_seed:

  set a seed for reproducibility

- seed_number:

  seed number

- verbose:

  verbose

## Value

Cell-Cell communication scores for feature pairs based on spatial
interaction

## Details

Statistical framework to identify if pairs of features (such as
ligand-receptor combinations) are expressed at higher levels than
expected based on a reshuffled null distribution of feature expression
values in cells that are spatially in proximity to each other.

- \* LR_comb: Pair of ligand and receptor \* lig_cell_type: cell type to
  assess expression level of ligand \* lig_expr: average expression
  residual (observed - DWLS_predicted) of ligand in lig_cell_type \*
  ligand: ligand name \* rec_cell_type: cell type to assess expression
  level of receptor \* rec_expr: average expression residual(observed -
  DWLS_predicted) of receptor in rec_cell_type \* receptor: receptor
  name \* LR_expr: combined average ligand and receptor expression \*
  lig_nr: total number of cells from lig_cell_type that spatially
  interact with cells from rec_cell_type \* rec_nr: total number of
  cells from rec_cell_type that spatially interact with cells from
  lig_cell_type \* rand_expr: average combined ligand and receptor
  expression residual from random spatial permutations \* av_diff:
  average difference between LR_expr and rand_expr over all random
  spatial permutations \* sd_diff: (optional) standard deviation of the
  difference between LR_expr and rand_expr over all random spatial
  permutations \* z_score: (optinal) z-score \* log2fc: LR_expr -
  rand_expr \* pvalue: p-value \* LR_cell_comb: cell type pair
  combination \* p.adj: adjusted p-value \* PI: significance score:
  log2fc \\ -log10(p.adj)
