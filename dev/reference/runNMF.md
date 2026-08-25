# Run Non-Negative Matrix Factorization

Use NMF to perform dimension reduction.

## Usage

``` r
runNMF(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  reduction = c("cells", "feats"),
  name = NULL,
  feats_to_use = "hvf",
  return_gobject = TRUE,
  scale_unit = TRUE,
  k = 20,
  method = c("rcppml"),
  rev = FALSE,
  set_seed = TRUE,
  seed_number = 1234,
  verbose = TRUE,
  toplevel = 1L,
  ...
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- expression_values:

  expression values to use

- reduction:

  "cells" or "feats"

- name:

  arbitrary name for NMF run

- feats_to_use:

  subset of features to use for NMF

- return_gobject:

  boolean: return giotto object (default = TRUE)

- scale_unit:

  scale features before NMF (default = TRUE)

- k:

  NMF rank (number of components to decompose into). Default is 20

- method:

  which implementation to use (only rcppml right now)

- rev:

  do a reverse NMF

- set_seed:

  use of seed

- seed_number:

  seed number to use

- verbose:

  verbosity of the function

- toplevel:

  relative stackframe where call was made

- ...:

  additional parameters for NMF (see details)

## Value

giotto object with updated NMF dimension reduction

## Details

See [`nmf`](https://rdrr.io/pkg/RcppML/man/nmf.html) for more
information about other parameters.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
x <- runNMF(g, k = 20)
x <- runUMAP(x,
    dim_reduction_to_use = "nmf",
    dimensions_to_use = 1:20,
    name = "nmf_umap"
)
x <- createNearestNetwork(x,
    dim_reduction_to_use = "nmf",
    dim_reduction_name = "nmf",
    dimensions_to_use = 1:20
)
x <- doLeidenCluster(x, name = "nmf_leiden", network_name = "sNN.nmf")
plotUMAP(x, dim_reduction_name = "nmf_umap", cell_color = "nmf_leiden")
spatPlot2D(x, cell_color = "nmf_leiden")
```
