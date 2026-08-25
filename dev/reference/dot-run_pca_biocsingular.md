# Run PCA - BiocSingular

Performs PCA based on the biocSingular package

## Usage

``` r
.run_pca_biocsingular(
  x,
  ncp = 100,
  center = TRUE,
  scale = TRUE,
  rev = FALSE,
  set_seed = TRUE,
  seed_number = 1234,
  BSPARAM = c("irlba", "exact", "random"),
  BPPARAM = BiocParallel::SerialParam(),
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

- BSPARAM:

  method to use

- BPPARAM:

  BiocParallelParam object

## Value

list of eigenvalues, loadings and pca coordinates
