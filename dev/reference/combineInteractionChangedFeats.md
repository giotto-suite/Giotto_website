# combineInteractionChangedFeats

Combine ICF scores in a pairwise manner.

## Usage

``` r
combineInteractionChangedFeats(
  icfObject,
  selected_ints = NULL,
  selected_feats = NULL,
  specific_feats_1 = NULL,
  specific_feats_2 = NULL,
  min_cells = 5,
  min_int_cells = 3,
  min_fdr = 0.05,
  min_spat_diff = 0,
  min_log2_fc = 0.5,
  do_parallel = TRUE,
  verbose = TRUE
)

combineICF(
  icfObject,
  selected_ints = NULL,
  selected_feats = NULL,
  specific_feats_1 = NULL,
  specific_feats_2 = NULL,
  min_cells = 5,
  min_int_cells = 3,
  min_fdr = 0.05,
  min_spat_diff = 0,
  min_log2_fc = 0.5,
  do_parallel = TRUE,
  verbose = TRUE
)
```

## Arguments

- icfObject:

  ICF (interaction changed feat) score object

- selected_ints:

  subset of selected cell-cell interactions (optional)

- selected_feats:

  subset of selected Features (optional)

- specific_feats_1:

  specific Featureset combo (need to position match specific_feats_2)

- specific_feats_2:

  specific Featureset combo (need to position match specific_feats_1)

- min_cells:

  minimum number of target cell type

- min_int_cells:

  minimum number of interacting cell type

- min_fdr:

  minimum adjusted p-value

- min_spat_diff:

  minimum absolute spatial expression difference

- min_log2_fc:

  minimum absolute log2 fold-change

- do_parallel:

  run calculations in parallel with mclapply

- verbose:

  verbose

## Value

\`combIcfObject\` that contains the filtered differential feature scores

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
g_icf <- findInteractionChangedFeats(g,
    cluster_column = "leiden_clus",
    selected_feats = c("Gna12", "Ccnd2", "Btbd17"),
    nr_permutations = 10
)

cicf <- combineInteractionChangedFeats(g_icf)
force(cicf)
combineICF(g_icf) # this is a shortened alias
```
