# loadOntraCResults

load ONTraC results

## Usage

``` r
loadOntraCResults(
  gobject,
  ontrac_results_dir = getwd(),
  preprocessing_dir = file.path(ontrac_results_dir, "preprocessing_dir"),
  GNN_dir = file.path(ontrac_results_dir, "GNN_dir"),
  NTScore_dir = file.path(ontrac_results_dir, "NTScore_dir"),
  NTScore_reverse = FALSE
)
```

## Arguments

- gobject:

  giotto object

- ontrac_results_dir:

  the directory where the ONTraC results are saved

- preprocessing_dir:

  the directory to save the preprocessing results. Default is
  file.path(ontrac_results_dir, "preprocessing_dir")

- GNN_dir:

  the directory to save the GNN results. Default is
  file.path(ontrac_results_dir, "GNN_dir")

- NTScore_dir:

  the directory to save the NTScore results. Default is
  file.path(ontrac_results_dir, "NTScore_dir")

- NTScore_reverse:

  whether to reverse the NTScore. Default is FALSE

## Value

gobject with ONTraC results

## Details

This function loads the ONTraC results into the giotto object.
