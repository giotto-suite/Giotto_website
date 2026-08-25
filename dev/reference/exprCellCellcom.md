# exprCellCellcom

Cell-Cell communication scores based on expression only

## Usage

``` r
exprCellCellcom(
  gobject,
  feat_type = NULL,
  spat_unit = NULL,
  cluster_column = "cell_types",
  random_iter = 1000,
  feat_set_1,
  feat_set_2,
  log2FC_addendum = 0.1,
  detailed = FALSE,
  adjust_method = c("fdr", "bonferroni", "BH", "holm", "hochberg", "hommel", "BY",
    "none"),
  adjust_target = c("feats", "cells"),
  set_seed = TRUE,
  seed_number = 1234,
  verbose = TRUE
)
```

## Arguments

- gobject:

  giotto object to use

- feat_type:

  feature type

- spat_unit:

  spatial unit

- cluster_column:

  cluster column with cell type information

- random_iter:

  number of iterations

- feat_set_1:

  first specific feature set from feature pairs

- feat_set_2:

  second specific feature set from feature pairs

- log2FC_addendum:

  addendum to add when calculating log2FC

- detailed:

  provide more detailed information (random variance and z-score)

- adjust_method:

  which method to adjust p-values

- adjust_target:

  adjust multiple hypotheses at the cell or feature level

- set_seed:

  \`logical\`. set seed for random simulations (default = TRUE)

- seed_number:

  seed number

- verbose:

  verbose

## Value

Cell-Cell communication scores for feature pairs based on expression
only

## Details

Statistical framework to identify if pairs of features (such as
ligand-receptor combinations) are expressed at higher levels than
expected based on a reshuffled null distribution of feature expression
values, without considering the spatial position of cells. More details
will follow soon.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

res <- exprCellCellcom(g,
    cluster_column = "leiden_clus",
    feat_set_1 = "Gm19935",
    feat_set_2 = "9630013A20Rik"
)

force(res)
```
