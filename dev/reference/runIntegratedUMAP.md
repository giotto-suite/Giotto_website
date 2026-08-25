# Run integrated UMAP

Run integrated UMAP

## Usage

``` r
runIntegratedUMAP(
  gobject,
  spat_unit = "cell",
  feat_types = c("rna", "protein"),
  integrated_feat_type = NULL,
  integration_method = "WNN",
  matrix_result_name = "theta_weighted_matrix",
  k = 20,
  spread = 5,
  min_dist = 0.01,
  force = FALSE,
  seed = 1234,
  ...
)
```

## Arguments

- gobject:

  A giotto object

- spat_unit:

  spatial unit

- feat_types:

  feature types to integrate. Default = c("rna", "protein")

- integrated_feat_type:

  integrated feature type (e.g. 'rna_protein')

- integration_method:

  multiomics integration method used. Default = 'WNN'

- matrix_result_name:

  Default = 'theta_weighted_matrix'

- k:

  k number

- spread:

  UMAP param: spread

- min_dist:

  UMAP param: min_dist

- force:

  force calculation of integrated kNN. Default = FALSE

- seed:

  seed. Default 1234

- ...:

  additional UMAP parameters

## Value

A Giotto object with integrated UMAP
