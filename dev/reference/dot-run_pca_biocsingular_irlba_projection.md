# Run PCA - BiocSingular irlba projection

Performs PCA based on the biocSingular package on a subset of the
matrix. It uses the obtained loadings to predicted coordinates for the
remaining matrix.

## Usage

``` r
.run_pca_biocsingular_irlba_projection(
  x,
  ncp = 100,
  center = TRUE,
  scale = TRUE,
  rev = FALSE,
  set_seed = TRUE,
  seed_number = 1234,
  BPPARAM = BiocParallel::SerialParam(),
  random_subset = 500,
  verbose = TRUE,
  ...
)
```

## Arguments

- x:

  matrix or object that can be converted to matrix

- ncp:

  number of principal components to calculate

- center:

  center the matrix before pca

- scale:

  scale features

- rev:

  reverse PCA

- set_seed:

  use of seed

- seed_number:

  seed number to use

- BPPARAM:

  BiocParallelParam object

- random_subset:

  random subset to perform PCA on

- verbose:

  verbosity level

## Value

list of eigenvalues, loadings and pca coordinates
