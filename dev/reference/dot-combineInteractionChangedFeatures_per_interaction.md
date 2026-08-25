# Combine ICF scores per interaction

Combine ICF scores per interaction

## Usage

``` r
.combineInteractionChangedFeatures_per_interaction(
  icfObject,
  sel_int,
  selected_feats = NULL,
  specific_feats_1 = NULL,
  specific_feats_2 = NULL,
  min_cells = 5,
  min_int_cells = 3,
  min_fdr = 0.05,
  min_spat_diff = 0,
  min_log2_fc = 0.5
)
```

## Value

data.table
