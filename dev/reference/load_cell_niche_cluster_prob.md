# load_cell_niche_cluster_prob

load cell-niche cluster probability

## Usage

``` r
load_cell_niche_cluster_prob(
  gobject,
  ontrac_results_dir = getwd(),
  GNN_dir = file.path(ontrac_results_dir, "GNN_dir"),
  spat_unit = "cell",
  feat_type = "niche cluster",
  name = "prob"
)
```

## Arguments

- gobject:

  giotto object

- ontrac_results_dir:

  the directory where the ONTraC results are saved. Default is getwd()

- GNN_dir:

  the directory to save the GNN results. Default is
  file.path(ontrac_results_dir, "GNN_dir")

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- name:

  name for the probability matrix

## Value

gobject with cell-niche cluster probability matrix

## Details

This function loads the ONTraC outputed cell-niche cluster probability
as an exprObj into the giotto object.
