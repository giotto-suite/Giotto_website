# cal_cell_niche_cluster_bin

calculate binarized cell-level niche cluster assignment

## Usage

``` r
cal_cell_niche_cluster_bin(
  gobject,
  spat_unit = "cell",
  feat_type = "niche cluster"
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

## Value

gobject with binarized cell-level niche cluster assignment
