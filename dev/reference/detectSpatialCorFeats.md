# Detect spatially correlated features

Detect features that are spatially correlated. Functions for starting
from either a gobject (`detectSpatialCorFeats()`) or individual pieces
of data (`detectSpatialCorFeatsMatrix()`) are provided.

## Usage

``` r
detectSpatialCorFeats(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  spat_loc_name = "raw",
  method = c("grid", "network"),
  expression_values = c("normalized", "scaled", "custom"),
  subset_feats = NULL,
  spatial_network_name = "Delaunay_network",
  network_smoothing = NULL,
  spatial_grid_name = "spatial_grid",
  min_cells_per_grid = 4,
  cor_method = c("pearson", "kendall", "spearman")
)

detectSpatialCorFeatsMatrix(
  expression_matrix,
  method = c("grid", "network"),
  spatial_network,
  spatial_grid,
  spatial_locs,
  subset_feats = NULL,
  network_smoothing = NULL,
  min_cells_per_grid = 4,
  cor_method = c("pearson", "kendall", "spearman")
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- spat_loc_name:

  name for spatial locations

- method:

  method to use for spatial averaging

- expression_values:

  gene expression values to use

- subset_feats:

  subset of features to use

- spatial_network_name:

  name of spatial network to use

- network_smoothing:

  smoothing factor between 0 and 1 (has automatic default, see details)

- spatial_grid_name:

  name of spatial grid to use

- min_cells_per_grid:

  minimum number of cells to consider a grid

- cor_method:

  correlation method

- expression_matrix:

  provided expression matrix

- spatial_network:

  provided spatial network

- spatial_grid:

  provided spatial grid

- spatial_locs:

  provided spatial locations

## Value

returns a spatial correlation object: `spatCorObject`

## Details

For `method = network`, it expects a fully connected spatial network.
You can make sure to create a fully connected network by setting
minimal_k \> 0 in the
[`createSpatialNetwork`](https://giotto-suite.github.io/GiottoClass/reference/createSpatialNetwork.html)
function.

1.  **grid-averaging:** average gene expression values within a
    predefined spatial grid

2.  **network-averaging:** smoothens the gene expression matrix by
    averaging the expression within one cell by using the neighbours
    within the predefined spatial network. \\b\\ is a smoothening factor
    passed by `network_smoothing` param that defaults to \\1 - 1/k\\,
    where \\k\\ is the median number of k-neighbors in the selected
    spatial network. Setting \\b = 0\\ means no smoothing and \\b = 1\\
    means no contribution from its own expression.

The `spatCorObject` can be further explored with
[`showSpatialCorFeats()`](https://giottosuite.com/dev/reference/showSpatialCorFeats.md)

## See also

[`showSpatialCorFeats`](https://giottosuite.com/dev/reference/showSpatialCorFeats.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

# Perform with data in a gobject
detectSpatialCorFeats(g, method = "network")

# This analysis can also be performed with data outside of the gobject
detectSpatialCorFeatsMatrix(
    expression_matrix = getExpression(
        g,
        output = "matrix"
    ),
    method = "network",
    spatial_network = getSpatialNetwork(g, output = "networkDT")
)
```
