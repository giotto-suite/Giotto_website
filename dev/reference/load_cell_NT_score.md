# load_cell_NT_score

load cell-level NT score

## Usage

``` r
load_cell_NT_score(
  gobject,
  ontrac_results_dir = getwd(),
  NTScore_dir = file.path(ontrac_results_dir, "NTScore_dir"),
  NTScore_reverse = FALSE
)
```

## Arguments

- gobject:

  giotto object

- ontrac_results_dir:

  the directory where the ONTraC results are saved. Default is getwd()

- NTScore_dir:

  the directory to save the NTScore results. Default is
  file.path(ontrac_results_dir, "NTScore_dir")

- NTScore_reverse:

  whether to reverse the NTScore. Default is FALSE

## Value

gobject with cell-level NT score

## Details

This function loads the ONTraC outputed cell-level NT score
