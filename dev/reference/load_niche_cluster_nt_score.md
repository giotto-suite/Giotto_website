# load_niche_cluster_nt_score

load niche cluster NT score

## Usage

``` r
load_niche_cluster_nt_score(
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

gobject with niche cluster NT score

## Details

This function loads the ONTraC outputed niche cluster NT score into the
giotto object.
