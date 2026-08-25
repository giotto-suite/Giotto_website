# Data clustering

Giotto provides several options for clustering using the
[`GiottoClass::clusterData()`](https://giotto-suite.github.io/GiottoClass/reference/clusterData.html)
generic. Clustering for matrix-like data hooks into the bluster
framework. Network community clustering type methods instead use
Giotto-specific implementations that work on top of Giotto's calculated
nearest neighbor networks.

## Usage

``` r
# S4 method for class 'allMatrix,BlusterParam'
clusterData(
  x,
  param,
  cell_subset = NULL,
  feat_subset = NULL,
  cells_are_rows = TRUE,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor", "full"),
  ...
)

# S4 method for class 'allMatrix,NNClusParam'
clusterData(x, param, ...)

# S4 method for class 'exprObj,BlusterParam'
clusterData(
  x,
  param,
  cell_subset = NULL,
  feat_subset = NULL,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor", "full"),
  ...
)

# S4 method for class 'dimObj,BlusterParam'
clusterData(
  x,
  param,
  cell_subset = NULL,
  feat_subset = 1:10,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor", "full"),
  ...
)

# S4 method for class 'spatEnrObj,BlusterParam'
clusterData(
  x,
  param,
  cell_subset = NULL,
  feat_subset = NULL,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor", "full"),
  ...
)

# S4 method for class 'nnNetObj,NNClusParam'
clusterData(
  x,
  param,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor"),
  ...
)

# S4 method for class 'igraph,LouvainCommunityClusParam'
clusterData(
  x,
  param,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor")
)

# S4 method for class 'igraph,LouvainMultinetClusParam'
clusterData(
  x,
  param,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor")
)

# S4 method for class 'igraph,LeidenPythonClusParam'
clusterData(
  x,
  param,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor")
)

# S4 method for class 'igraph,LeidenIgraphClusParam'
clusterData(
  x,
  param,
  set_seed = TRUE,
  seed_number = 1234,
  output = c("data.table", "factor"),
  ...
)

# S4 method for class 'giotto,BlusterParam'
clusterData(
  x,
  param,
  what = c("expression", "dimension_reduction", "spatial_enrichment"),
  name = paste(class(param), "clusters", sep = "_"),
  dim_reduction_to_use = "pca",
  dim_reduction_name = "pca",
  expression_values = "normalized",
  spat_enr_name = NULL,
  spat_unit = NULL,
  feat_type = NULL,
  output = c("gobject", "data.table", "factor", "full"),
  .n = 1L,
  ...
)

# S4 method for class 'giotto,NNClusParam'
clusterData(
  x,
  param,
  name = paste(class(param), "clusters", sep = "_"),
  nn_network_to_use = "sNN",
  network_name = "sNN.pca",
  spat_unit = NULL,
  feat_type = NULL,
  output = c("gobject", "data.table", "factor"),
  .n = 1L,
  ...
)
```

## Arguments

- x:

  data object to cluster

- param:

  S4 param class inheriting from
  [bluster::BlusterParam](https://rdrr.io/pkg/bluster/man/BlusterParam-class.html)
  or
  [NNClusParam](https://giottosuite.com/dev/reference/NNClusParam-class.md)

- cell_subset:

  numeric, logical, factor, or character vector of cells to use.
  (matrix-like clustering only)

- feat_subset:

  numeric, logical, factor, or character vector of features or
  dimensions to use. (matrix-like clustering only)

- cells_are_rows:

  logical. Transposes the input matrix when `FALSE`. Mainly here to
  highlight that clustering is performed on row-wise cells.

- set_seed:

  logical, default = `TRUE`. Whether to set a seed for reproducibility.

- seed_number:

  numeric, default = 1234. If `set_seed = TRUE`, seed number to use.

- output:

  character. Type of output.

  - `"factor"` returns a numeric factor of clustering results, named by
    cell_ID.

  - `"data.table"` returns a two column (or one if no cell_IDs are
    present) with columns `"cell_ID"` and `"cluster"`.

  - `"full"` returns the full output. It is equivalent to setting
    `full = TRUE` for
    [`bluster::clusterRows()`](https://rdrr.io/pkg/bluster/man/clusterRows.html).

  - `"gobject"` can only be selected when `x` is a `giotto` object. The
    clustering results are appended to the cell metadata column
    designated by `name` param and the `giotto` object is returned.

- ...:

  additional params to pass to underlying algorithms, if any.

- what:

  character. One of `"expression"`, `"dimension_reduction"`, or
  `"spatial_enrichment"` indicating what data in `giotto` object to
  cluster. (matrix-like clustering only)

- name:

  character. When `output = "gobject"`, the name to assign the column of
  clustering results in cell metadata.

- dim_reduction_to_use:

  character. Type of dimension reduction to use.

- dim_reduction_name:

  character. Name of dimension reduction results to use.

- expression_values:

  character. Name of expression values to use

- spat_enr_name:

  character. Name of spatial enrichment values to use.

- spat_unit:

  character. Spatial unit to use. NULL will autodetect based on active
  spatial unit.

- feat_type:

  character. Feature type to use. NULL will autodetect based on active
  feature type.

- .n:

  integer. Used in recording object history (see
  [`update_giotto_params()`](https://giotto-suite.github.io/GiottoClass/reference/update_giotto_params.html)).
  Number of stack frames back to record call of interest. Set to a large
  negative number (e.g. -1000) to avoid recording altogether (useful
  when there is another record call elsewhere in the stack you want to
  use.)

- nn_network_to_use:

  character. Type of nearest neighbor network to use. Currently one of
  `"sNN"` or `"kNN"`.

- network_name:

  character. Name of nearest neighbor network to use.

## See also

[`clusterParam()`](https://giottosuite.com/dev/reference/clusterParam.md)
for a convenient factory function to generate clustering param classes.

## Examples

``` r
x <- clusterParam("kmeans", centers = 2)
x@centers

m <- matrix(runif(9), nrow = 3)
clusterData(m, x)
# add ids
rownames(m) <- paste("id", seq_len(3), sep = "_")
clusterData(m, x)
```
