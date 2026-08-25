# filterInteractionChangedFeats

Filter Interaction Changed Feature scores.

## Usage

``` r
filterInteractionChangedFeats(
  icfObject,
  min_cells = 4,
  min_cells_expr = 1,
  min_int_cells = 4,
  min_int_cells_expr = 1,
  min_fdr = 0.1,
  min_spat_diff = 0.2,
  min_log2_fc = 0.2,
  min_zscore = 2,
  zscores_column = c("cell_type", "feats"),
  direction = c("both", "up", "down")
)

filterICF(
  icfObject,
  min_cells = 4,
  min_cells_expr = 1,
  min_int_cells = 4,
  min_int_cells_expr = 1,
  min_fdr = 0.1,
  min_spat_diff = 0.2,
  min_log2_fc = 0.2,
  min_zscore = 2,
  zscores_column = c("cell_type", "feats"),
  direction = c("both", "up", "down")
)
```

## Arguments

- icfObject:

  ICF (interaction changed feature) score object

- min_cells:

  minimum number of source cell type

- min_cells_expr:

  minimum expression level for source cell type

- min_int_cells:

  minimum number of interacting neighbor cell type

- min_int_cells_expr:

  minimum expression level for interacting neighbor cell type

- min_fdr:

  minimum adjusted p-value

- min_spat_diff:

  minimum absolute spatial expression difference

- min_log2_fc:

  minimum log2 fold-change

- min_zscore:

  minimum z-score change

- zscores_column:

  calculate z-scores over cell types or genes

- direction:

  differential expression directions to keep

## Value

`icfObject` that contains the filtered differential feature scores

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

icf <- findInteractionChangedFeats(g,
    cluster_column = "leiden_clus",
    selected_feats = c("Gna12", "Ccnd2", "Btbd17"),
    nr_permutations = 10
)
force(icf)
force(icf$ICFscores)

icf_filter1 <- filterInteractionChangedFeats(icf, min_cells = 4)
force(icf_filter1)
force(icf_filter1$ICFscores)

# filterICF is a simple alias with a shortened name
icf_filter2 <- filterICF(icf, min_cells = 4)
force(icf_filter2)
```
