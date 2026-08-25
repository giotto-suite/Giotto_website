# do_spatial_knn_smoothing

smooth gene expression over a kNN spatial network

## Usage

``` r
do_spatial_knn_smoothing(
  expression_matrix,
  spatial_network,
  subset_feats = NULL,
  b = NULL
)
```

## Arguments

- expression_matrix:

  gene expression values to use

- spatial_network:

  spatial network to use

- subset_feats:

  subset of features to use

- b:

  smoothing factor beteen 0 and 1 (default: automatic)

## Value

matrix with smoothened gene expression values based on kNN spatial
network

## Details

This function will smoothen the gene expression values per cell
according to its neighbors in the selected spatial network.  
b is a smoothening factor that defaults to 1 - 1/k, where k is the
median number of k-neighbors in the selected spatial network. Setting b
= 0 means no smoothing and b = 1 means no contribution from its own
expression.
