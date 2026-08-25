# findInteractionChangedFeats

Identifies cell-to-cell Interaction Changed Features (ICF), i.e.
features that are differentially expressed due to proximity to other
cell types. This function is appropriate for single-cell level data. For
data from spot-based spatial assays or spatially binned data, see
[`findICFSpot()`](https://giottosuite.com/dev/reference/findICFSpot.md),
which runs on top of DWLS results or similar spot-level cell-type
enrichment outputs

## Usage

``` r
findInteractionChangedFeats(
  gobject,
  feat_type = NULL,
  spat_unit = NULL,
  expression_values = "normalized",
  selected_feats = NULL,
  cluster_column,
  spatial_network_name = "Delaunay_network",
  minimum_unique_cells = 1,
  minimum_unique_int_cells = 1,
  diff_test = c("permutation", "limma", "t.test", "wilcox"),
  mean_method = c("arithmic", "geometric"),
  offset = 0.1,
  adjust_method = c("bonferroni", "BH", "holm", "hochberg", "hommel", "BY", "fdr",
    "none"),
  nr_permutations = 1000,
  exclude_selected_cells_from_test = TRUE,
  do_parallel = TRUE,
  set_seed = TRUE,
  seed_number = 1234
)

findICF(
  gobject,
  feat_type = NULL,
  spat_unit = NULL,
  expression_values = "normalized",
  selected_feats = NULL,
  cluster_column,
  spatial_network_name = "Delaunay_network",
  minimum_unique_cells = 1,
  minimum_unique_int_cells = 1,
  diff_test = c("permutation", "limma", "t.test", "wilcox"),
  mean_method = c("arithmic", "geometric"),
  offset = 0.1,
  adjust_method = c("bonferroni", "BH", "holm", "hochberg", "hommel", "BY", "fdr",
    "none"),
  nr_permutations = 1000,
  exclude_selected_cells_from_test = TRUE,
  do_parallel = TRUE,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Arguments

- gobject:

  giotto object

- feat_type:

  feature type

- spat_unit:

  spatial unit

- expression_values:

  expression values to use

- selected_feats:

  subset of selected features (optional)

- cluster_column:

  name of column to use for cell types

- spatial_network_name:

  name of spatial network to use

- minimum_unique_cells:

  minimum number of target cells required

- minimum_unique_int_cells:

  minimum number of interacting cells required

- diff_test:

  which differential expression test

- mean_method:

  method to use to calculate the mean

- offset:

  offset value to use when calculating log2 ratio

- adjust_method:

  which method to adjust p-values

- nr_permutations:

  number of permutations if diff_test = permutation

- exclude_selected_cells_from_test:

  exclude interacting cells other cells

- do_parallel:

  run calculations in parallel with mclapply

- set_seed:

  set a seed for reproducibility

- seed_number:

  seed number

## Value

`icfObject` that contains the Interaction Changed differential feature
scores

## Details

Function to calculate if features are differentially expressed in cell
types when they interact (approximated by physical proximity) with other
cell types. The results data.table in the `icfObject` contains

- at least - the following columns:

  - **features:** All or selected list of tested features

  - **sel:** average feature expression in the interacting cells from
    the target cell type

  - **other:** average feature expression in the NOT-interacting cells
    from the target cell type

  - **log2fc:** log2 fold-change between sel and other

  - **diff:** spatial expression difference between sel and other

  - **p.value:** associated p-value

  - **p.adj:** adjusted p-value

  - **cell_type:** target cell type

  - **int_cell_type:** interacting cell type

  - **nr_select:** number of cells for selected target cell type

  - **int_nr_select:** number of cells for interacting cell type

  - **nr_other:** number of other cells of selected target cell type

  - **int_nr_other:** number of other cells for interacting cell type

  - **unif_int:** cell-cell interaction

## See also

[`filterInteractionChangedFeats()`](https://giottosuite.com/dev/reference/filterInteractionChangedFeats.md)
[`findICFSpot()`](https://giottosuite.com/dev/reference/findICFSpot.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

icf1 <- findInteractionChangedFeats(g,
    cluster_column = "leiden_clus",
    selected_feats = c("Gna12", "Ccnd2", "Btbd17"),
    nr_permutations = 10
)
force(icf1)
force(icf1$ICFscores)

# this is just an alias with a shorter name
icf2 <- findICF(g,
    cluster_column = "leiden_clus",
    selected_feats = c("Gna12", "Ccnd2", "Btbd17"),
    nr_permutations = 10
)
```
