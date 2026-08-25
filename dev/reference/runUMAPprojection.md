# Run UMAP dimension reduction

run UMAP on subset and project on the rest

## Usage

``` r
runUMAPprojection(
  gobject,
  feat_type = NULL,
  spat_unit = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  reduction = c("cells", "feats"),
  dim_reduction_to_use = "pca",
  dim_reduction_name = NULL,
  dimensions_to_use = 1:10,
  random_subset = 500,
  name = NULL,
  feats_to_use = NULL,
  return_gobject = TRUE,
  n_neighbors = 40,
  n_components = 2,
  n_epochs = 400,
  min_dist = 0.01,
  n_threads = NA,
  spread = 5,
  set_seed = TRUE,
  seed_number = 1234,
  verbose = TRUE,
  toplevel_params = deprecated(),
  toplevel = 1L,
  ...
)
```

## Arguments

- gobject:

  giotto object

- feat_type:

  feature type

- spat_unit:

  spatial unit

- expression_values:

  expression values to use

- reduction:

  'cells' or 'feats'

- dim_reduction_to_use:

  use another dimension reduction set as input

- dim_reduction_name:

  name of dimension reduction set to use

- dimensions_to_use:

  number of dimensions to use as input

- random_subset:

  random subset to perform UMAP on

- name:

  arbitrary name for UMAP run

- feats_to_use:

  if dim_reduction_to_use = NULL, which features to use

- return_gobject:

  boolean: return giotto object (default = TRUE)

- n_neighbors:

  UMAP param: number of neighbors

- n_components:

  UMAP param: number of components

- n_epochs:

  UMAP param: number of epochs

- min_dist:

  UMAP param: minimum distance

- n_threads:

  UMAP param: threads/cores to use

- spread:

  UMAP param: spread

- set_seed:

  use of seed

- seed_number:

  seed number to use

- verbose:

  verbosity of function

- toplevel_params:

  deprecated

- toplevel:

  relative stackframe where call was made from

- ...:

  additional UMAP parameters

## Value

giotto object with updated UMAP dimension reduction

## Details

See [`umap`](https://jlmelville.github.io/uwot/reference/umap.html) for
more information about these and other parameters.

- Input for UMAP dimension reduction can be another dimension reduction
  (default = 'pca')

- To use gene expression as input set dim_reduction_to_use = NULL

- If dim_reduction_to_use = NULL, feats_to_use can be used to select a
  column name of highly variable genes (see
  [`calculateHVF`](https://giottosuite.com/dev/reference/calculateHVF.md))
  or simply provide a vector of genes

- multiple UMAP results can be stored by changing the *name* of the
  analysis

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

runUMAPprojection(g)
```
