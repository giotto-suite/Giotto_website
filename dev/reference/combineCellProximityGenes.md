# deprecated

Combine ICF scores in a pairwise manner.

## Usage

``` r
combineCellProximityGenes(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`combineInteractionChangedFeats`](https://giottosuite.com/dev/reference/combineInteractionChangedFeats.md)

  `icfObject`

  :   ICF (interaction changed feat) score object

  `selected_ints`

  :   subset of selected cell-cell interactions (optional)

  `selected_feats`

  :   subset of selected Features (optional)

  `specific_feats_1`

  :   specific Featureset combo (need to position match
      specific_feats_2)

  `specific_feats_2`

  :   specific Featureset combo (need to position match
      specific_feats_1)

  `min_cells`

  :   minimum number of target cell type

  `min_int_cells`

  :   minimum number of interacting cell type

  `min_fdr`

  :   minimum adjusted p-value

  `min_spat_diff`

  :   minimum absolute spatial expression difference

  `min_log2_fc`

  :   minimum absolute log2 fold-change

  `do_parallel`

  :   run calculations in parallel with mclapply

  `verbose`

  :   verbose

## Value

ICF scores

## See also

[`combineInteractionChangedFeats`](https://giottosuite.com/dev/reference/combineInteractionChangedFeats.md)
