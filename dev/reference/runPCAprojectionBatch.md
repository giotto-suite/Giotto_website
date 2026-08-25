# runPCAprojectionBatch

runs a Principal Component Analysis on multiple random batches +
projection

## Usage

``` r
runPCAprojectionBatch(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  reduction = c("cells", "feats"),
  random_subset = 500,
  batch_number = 5,
  name = "pca.projection.batch",
  feats_to_use = "hvf",
  return_gobject = TRUE,
  center = TRUE,
  scale_unit = TRUE,
  ncp = 100,
  method = c("irlba"),
  method_params = BiocParallel::SerialParam(),
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

  spatial unit

- feat_type:

  feature type

- expression_values:

  expression values to use

- reduction:

  cells or genes

- random_subset:

  random subset to perform PCA on

- batch_number:

  number of random batches to run

- name:

  arbitrary name for PCA run

- feats_to_use:

  subset of features to use for PCA

- return_gobject:

  boolean: return giotto object (default = TRUE)

- center:

  center data first (default = TRUE)

- scale_unit:

  scale features before PCA (default = TRUE)

- ncp:

  number of principal components to calculate

- method:

  which implementation to use

- method_params:

  BiocParallelParam object

- rev:

  do a reverse PCA

- set_seed:

  use of seed

- seed_number:

  seed number to use

- verbose:

  verbosity of the function

- toplevel:

  relative stackframe where call was made

- ...:

  additional parameters for PCA (see details)

## Value

giotto object with updated PCA dimension reduction

## Details

See [`runPCA`](https://rdrr.io/pkg/BiocSingular/man/runPCA.html) and
`PCA` for more information about other parameters. This PCA
implementation is similar to
[`runPCA`](https://giottosuite.com/dev/reference/runPCA.md) and
[`runPCAprojection`](https://giottosuite.com/dev/reference/runPCAprojection.md),
except that it performs PCA on multiple subsets (batches) of the cells
or features, and predict on the others. This can significantly increase
speed without sacrificing accuracy too much.

- feats_to_use = NULL: will use all features from the selected matrix

- feats_to_use = \<hvg name\>: can be used to select a column name of
  highly variable features, created by (see
  [`calculateHVF`](https://giottosuite.com/dev/reference/calculateHVF.md))

- feats_to_use = c('geneA', 'geneB', ...): will use all manually
  provided features

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

# set feats_to_use to NULL since there are not many hvfs
# (only 48 in this mini dataset)
runPCAprojectionBatch(g, feats_to_use = NULL)
```
