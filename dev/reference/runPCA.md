# runPCA

runs a Principal Component Analysis

## Usage

``` r
runPCA(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  reduction = c("cells", "feats"),
  name = NULL,
  feats_to_use = "hvf",
  return_gobject = TRUE,
  center = TRUE,
  scale_unit = TRUE,
  ncp = 100,
  method = c("irlba", "exact", "random", "factominer"),
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

  number of principal components to calculate (see details)

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

giotto object with updated PCA dimension recuction

## Details

See [`runPCA`](https://rdrr.io/pkg/BiocSingular/man/runPCA.html) and
`PCA` for more information about other parameters. With the feats_to_use
param, you can control which features are used to calculate your PCA,
which can be useful for making sure that your downstream dimension
reduction and clusterings are based on your features of interest.

- feats_to_use = NULL: will use all features from the selected matrix

- feats_to_use = \<hvg name\>: can be used to select a column name of
  highly variable features, created by (see
  [`calculateHVF`](https://giottosuite.com/dev/reference/calculateHVF.md))

- feats_to_use = c('geneA', 'geneB', ...): will use all manually
  provided features

By default the number of principle components that we calculate is 100,
which may not encompass all the variation within the dataset. Setting
ncp to NULL will calculate all the principle components.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

runPCA(g)
```
