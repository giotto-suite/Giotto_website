# load_nc_connectivity

load niche cluster connectivity

## Usage

``` r
load_nc_connectivity(
  gobject,
  ontrac_results_dir = getwd(),
  GNN_dir = file.path(ontrac_results_dir, "GNN_dir"),
  spat_unit = "niche cluster",
  feat_type = "connectivity",
  name = "normalized"
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

  name for the connectivity matrix

## Value

gobject with niche cluster connectivity matrix

## Details

This function loads the ONTraC outputed niche cluster connectivity
matrix as an exprObj into the giotto object.
