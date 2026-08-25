# Projection of cluster labels

Use a fast KNN classifier to predict labels from a smaller giotto object

## Usage

``` r
doClusterProjection(
  target_gobject,
  target_cluster_label_name = "knn_labels",
  spat_unit = NULL,
  feat_type = NULL,
  source_gobject,
  source_cluster_labels = NULL,
  reduction = "cells",
  reduction_method = "pca",
  reduction_name = "pca",
  dimensions_to_use = 1:10,
  knn_k = 10,
  prob = FALSE,
  algorithm = c("kd_tree", "cover_tree", "brute"),
  return_gobject = TRUE
)
```

## Arguments

- target_gobject:

  target giotto object

- target_cluster_label_name:

  name for predicted clusters

- spat_unit:

  spatial unit

- feat_type:

  feature type

- source_gobject:

  source giotto object with annotation data

- source_cluster_labels:

  annotation/labels to use to train KNN classifier

- reduction:

  reduction on cells or features (default = cells)

- reduction_method:

  shared reduction method (default = pca space)

- reduction_name:

  name of shared reduction space (default name = 'pca')

- dimensions_to_use:

  dimensions to use in shared reduction space (default = 1:10)

- knn_k:

  number of k-neighbors to train a KNN classifier

- prob:

  output probabilities together with label predictions

- algorithm:

  nearest neighbor search algorithm

- return_gobject:

  return giotto object

## Value

giotto object (default) or data.table with cell metadata

## Details

Function to train a KNN with
[`knn`](https://rdrr.io/pkg/FNN/man/knn.html). The training data is
obtained from the source giotto object (source_gobject) using existing
annotations within the cell metadata. Cells without annotation/labels
from the target giotto object (target_gobject) will receive predicted
labels (and optional probabilities with prob = TRUE).

\*\*IMPORTANT\*\* This projection assumes that you're using the same
dimension reduction space (e.g. PCA) and number of dimensions (e.g.
first 10 PCs) to train the KNN classifier as you used to create the
initial annotations/labels in the source Giotto object.

Altogether this is a convenience function that allow you to work with
very big data as you can predict cell labels on a smaller & subsetted
Giotto object and then project the cell labels to the remaining cells in
the target Giotto object.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
x <- pDataDT(g)
g_small <- subsetGiotto(g, cell_ids = sample(x$cell_ID, 300))
doClusterProjection(
    target_gobject = g, source_gobject = g_small,
    source_cluster_labels = "leiden_clus"
)
```
