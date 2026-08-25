# Transfer labels/annotations between sets of data via similarity voting

When two sets of data share an embedding space, transfer the labels from
one of the sets to the other based on KNN similarity voting in that
space.

## Usage

``` r
# S4 method for class 'giotto,giotto'
labelTransfer(
  x,
  y,
  labels,
  k = 10,
  name = paste0("trnsfr_", labels),
  integration_method = c("none", "harmony"),
  prob = TRUE,
  reduction = "cells",
  reduction_method = "pca",
  reduction_name = "pca",
  dimensions_to_use = 1:10,
  spat_unit = NULL,
  feat_type = NULL,
  return_gobject = TRUE,
  ...
)

# S4 method for class 'giotto,missing'
labelTransfer(
  x,
  spat_unit = NULL,
  feat_type = NULL,
  source_cell_ids,
  target_cell_ids,
  labels,
  k = 10,
  name = paste0("trnsfr_", labels),
  prob = TRUE,
  reduction = "cells",
  reduction_method = "pca",
  reduction_name = "pca",
  dimensions_to_use = 1:10,
  return_gobject = TRUE,
  ...
)
```

## Arguments

- x:

  target object

- y:

  source object

- labels:

  metadata column in source with labels to transfer

- k:

  number of k-neighbors to train a KNN classifier

- name:

  metadata column in target to apply the full set of labels to

- integration_method:

  character. Integration method to use when transferring labels. Options
  are "none" (default) and "harmony". See section below for more info
  and params.

- prob:

  output knn probabilities together with label predictions

- reduction:

  reduction on cells or features (default = "cells")

- reduction_method:

  shared reduction method (default = "pca" space)

- reduction_name:

  name of shared reduction space (default name = "pca")

- dimensions_to_use:

  dimensions to use in shared reduction space (default = 1:10)

- spat_unit:

  spatial unit. A character vector of 2 can also be passed for x (1) and
  y (2). Setting defaults with
  [`activeSpatUnit()`](https://giotto-suite.github.io/GiottoClass/reference/activeSpatUnit-generic.html)
  may be easier

- feat_type:

  feature type. A character vector of 2 can also be passed for x (1) and
  y (2). Setting defaults with
  [`activeFeatType()`](https://giotto-suite.github.io/GiottoClass/reference/activeFeatType-generic.html)
  may be easier

- ...:

  Arguments passed on to
  [`FNN::knn`](https://rdrr.io/pkg/FNN/man/knn.html)

  `algorithm`

  :   nearest neighbor search algorithm.

- source_cell_ids:

  cell/spatial IDs with the source labels to transfer

- target_cell_ids:

  cell/spatial IDs to transfer the labels to. IDs from `source_cell_ids`
  are always included as well.

## Value

object `x` with new transferred labels added to metadata. If running on
`x` and `y` objects, `integration_method = "harmony"`,
`plot_join_labels = TRUE`, and `return_plot = TRUE` is set, output will
be instead a named list of `gobject` (updated `x`), and
`label_source_plot` and `label_target_plot` `ggplot2` objects

## Details

This function trains a KNN classifier with
[`FNN::knn()`](https://rdrr.io/pkg/FNN/man/knn.html). The training data
is from object `y` or `source_cell_ids` subset in `x` and uses existing
annotations within the cell metadata. Cells without annotation/labels
from `x` or `target_cell_ids` subset in `x` will receive predicted
labels (and optional probabilities when `prob = TRUE`).

**IMPORTANT** This projection assumes that you're using the same
dimension reduction space (e.g. PCA) and number of dimensions (e.g.
first 10 PCs) to train the KNN classifier as you used to create the
initial annotations/labels in the source Giotto object.

This function can allow you to work with very big data as you can
predict cell labels on a smaller & subsetted Giotto object and then
project the cell labels to the remaining cells in the target Giotto
object. It can also be used to transfer labels from one set of annotated
data to another dataset based on expression similarity after joining and
integrating.

## integration_method

When running `labelTranfer()` on two `giotto` objects, an integration
pipeline can also be run to align the two datasets together before the
transfer. `integration_method = "harmony"` will make a temporary joined
object on shared features, filter to remove 0 values, run PCA, then
harmony integration, before performing the label transfer from `y` to
`x` on the integrated harmony embedding space. Additional params that
can be used with this method are:  

- `source_cell_ids` - character. subset of `y` cells to use

- `target_cell_ids` - character. subset of `x` cells to use

- `expression_values` - character. expression values in `x` and `y` to
  use to generate combined space. Default = `"raw"`

- `use_hvf` - logical. whether to calculate highly variable features to
  use for PCA calculation. Default = `TRUE`, but setting `FALSE` is
  recommended if any of `x` or `y` has roughly 1000 features or fewer

- `plot_join_labels` - logical. Whether to plot source labels and final
  labels in the joine object UMAP.

- `normalize_params` - named list. Additional params to pass to
  [`normalizeGiotto()`](https://giottosuite.com/dev/reference/normalizeGiotto.md)
  if desired.

- `pca_params` - named list. Additional params to pass to
  [`runPCA()`](https://giottosuite.com/dev/reference/runPCA.md) if
  desired.

- `integration_params` - named list. Additional params to pass to
  [`runGiottoHarmony()`](https://giottosuite.com/dev/reference/runGiottoHarmony.md)
  if desired.

- `plot_params` - named list. Additional params to pass to
  [`plotUMAP()`](https://giotto-suite.github.io/GiottoVisuals/reference/plotUMAP.html)
  if desired. Only relevant when `plot_join_labels = TRUE`

- `verbose` - verbosity

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
id_subset <- sample(spatIDs(g), 300)
n_pred <- nrow(pDataDT(g)) - 300

# transfer labels from one object to another ###################
g_small <- g[, id_subset]
# additional steps to get labels to transfer on smaller object...
g <- labelTransfer(g, g_small, labels = "leiden_clus")

# transfer labels between subsets of a single object ###########
g <- labelTransfer(g,
    label = "leiden_clus", source_cell_ids = id_subset, name = "knn_leiden2"
)
```
