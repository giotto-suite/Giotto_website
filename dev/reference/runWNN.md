# Multi omics integration with WNN

Multi omics integration with WNN

## Usage

``` r
runWNN(
  gobject,
  spat_unit = "cell",
  feat_types = c("rna", "protein"),
  reduction_methods = c("pca", "pca"),
  reduction_names = c("rna.pca", "protein.pca"),
  k = 20,
  integrated_feat_type = NULL,
  matrix_result_name = NULL,
  w_names = c(NULL, NULL),
  verbose = FALSE
)
```

## Arguments

- gobject:

  A Giotto object with individual PCA feat_types pre-calculated

- spat_unit:

  spatial unit

- feat_types:

  feature types to integrate. Default = c("rna", "protein")

- reduction_methods:

  reduction methods for each feature type. Default = c("pca", "pca")

- reduction_names:

  names of the reduction methods to use. Default = c("rna.pca",
  "protein.pca")

- k:

  number of neighbors to calculate cell distances, default = 20

- integrated_feat_type:

  integrated feature type (e.g. 'rna_protein')

- matrix_result_name:

  Default = 'theta_weighted_matrix'

- w_names:

  optional. Names for the weighted matrices. If NULL, automatic names
  composed by w_feat_type will be created.

- verbose:

  be verbose

## Value

A Giotto object with a new multiomics slot containing the
theta_weighted_matrix and individual weight matrices.
