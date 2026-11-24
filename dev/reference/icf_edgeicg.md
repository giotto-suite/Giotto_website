# edgeicg interaction-changed features

The
[`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
method for an
[edgeIcfParam](https://giottosuite.com/dev/reference/icf_param.md) on an
expression matrix. The computation is done by the edgeicg package, which
is suggested rather than imported: install it with
`remotes::install_github("drieslab/edgeicg")`.

## Usage

``` r
# S4 method for class 'ANY,edgeIcfParam'
analyzeData(
  x,
  param,
  ...,
  coords,
  cell_type,
  lib,
  spill_edges = NULL,
  feats = NULL,
  region = NULL
)

# S4 method for class 'giotto,icfParam'
analyzeData(
  x,
  param,
  spat_unit = NULL,
  feat_type = NULL,
  cluster_column = NULL,
  selected_feats = NULL,
  ...
)
```

## Arguments

- x:

  raw counts, features by cells: a `matrix` or `Matrix`, or a GiottoDisk
  expression store, which edgeicg reads in windows without loading it.

- param:

  an [edgeIcfParam](https://giottosuite.com/dev/reference/icf_param.md).

- ...:

  unused. Declared because
  [`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
  carries it.

- coords:

  numeric matrix of cell centroids (x, y), row names = cell IDs.

- cell_type:

  cell type labels named by cell ID.

- lib:

  library size per cell over all features, named by cell ID.

- spill_edges:

  optional touching-cell edges (`recv`, `send`, `w`) with `recv` /
  `send` indexing `colnames(x)`.

- feats:

  optional subset of features to test.

- region:

  optional region per cell, named by cell ID.

- spat_unit, feat_type:

  spatial unit and feature type

- cluster_column:

  cell metadata column holding cell type labels

- selected_feats:

  optional subset of features to test

## Value

an `EdgeICG` fit (see `edgeicg::edgeicg()`).
