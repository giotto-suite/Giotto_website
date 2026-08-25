# runSpatialDeconv

Function to perform deconvolution based on single cell expression data

## Usage

``` r
runSpatialDeconv(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  deconv_method = c("DWLS"),
  expression_values = c("normalized"),
  logbase = 2,
  cluster_column = "leiden_clus",
  sign_matrix,
  n_cell = 50,
  cutoff = 2,
  name = NULL,
  return_gobject = TRUE
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- deconv_method:

  method to use for deconvolution

- expression_values:

  expression values to use

- logbase:

  base used for log normalization

- cluster_column:

  name of cluster column

- sign_matrix:

  signature matrix for deconvolution

- n_cell:

  number of cells per spot

- cutoff:

  cut off (default = 2)

- name:

  name to give to spatial deconvolution results

- return_gobject:

  return giotto object

## Value

giotto object or deconvolution results

## See also

[`runDWLSDeconv`](https://giottosuite.com/dev/reference/runDWLSDeconv.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
x <- findMarkers_one_vs_all(g,
    cluster_column = "leiden_clus", min_feats = 20
)
sign_gene <- x$feats

sign_matrix <- matrix(rnorm(length(sign_gene) * 8, mean = 10),
    nrow = length(sign_gene)
)
rownames(sign_matrix) <- sign_gene
colnames(sign_matrix) <- paste0("celltype_", unique(x$cluster))

runSpatialDeconv(gobject = g, sign_matrix = sign_matrix)
```
