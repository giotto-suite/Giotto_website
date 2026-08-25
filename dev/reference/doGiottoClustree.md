# doGiottoClustree

cluster cells using leiden methodology to visualize different
resolutions

## Usage

``` r
doGiottoClustree(
  gobject,
  res_vector = NULL,
  res_seq = NULL,
  return_gobject = FALSE,
  show_plot = NULL,
  save_plot = NULL,
  return_plot = NULL,
  save_param = list(),
  default_save_name = "clustree",
  verbose = TRUE,
  ...
)
```

## Arguments

- gobject:

  giotto object

- res_vector:

  vector of different resolutions to test

- res_seq:

  list of float numbers indicating start, end, and step size for
  resolution testing, i.e. (0.1, 0.6, 0.1)

- return_gobject:

  default FALSE. See details for more info.

- show_plot:

  by default, pulls from provided gobject instructions

- save_plot:

  by default, pulls from provided gobject instructions

- return_plot:

  by default, pulls from provided gobject instructions

- save_param:

  list of saving parameters from
  [`GiottoVisuals::all_plots_save_function()`](https://giotto-suite.github.io/GiottoVisuals/reference/plot_save.html)

- default_save_name:

  name of saved plot, default "clustree"

- verbose:

  be verbose

- ...:

  Arguments passed on to `clustree::clustree`

  :   

## Value

a plot object (default), OR a giotto object (if specified)

## Details

This function tests different resolutions for Leiden clustering and
provides a visualization of cluster sizing as resolution varies.

By default, the tested leiden clusters are NOT saved to the Giotto
object, and a plot is returned.

If return_gobject is set to TRUE, and a giotto object with *all* tested
leiden cluster information will be returned.

## See also

[`doLeidenCluster`](https://giottosuite.com/dev/reference/doLeidenCluster.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

doGiottoClustree(
    gobject = g, res_vector = c(0.5, 0.8), return_plot = FALSE,
    show_plot = FALSE, save_plot = FALSE
)
```
