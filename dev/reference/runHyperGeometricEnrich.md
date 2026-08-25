# runHyperGeometricEnrich

Function to calculate gene signature enrichment scores per spatial
position using a hypergeometric test.

## Usage

``` r
runHyperGeometricEnrich(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  sign_matrix,
  expression_values = c("normalized", "scaled", "custom"),
  reverse_log_scale = TRUE,
  logbase = 2,
  top_percentage = 5,
  output_enrichment = c("original", "zscore"),
  p_value = FALSE,
  name = NULL,
  return_gobject = TRUE
)
```

## Arguments

- gobject:

  Giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- sign_matrix:

  Matrix of signature genes for each cell type / process

- expression_values:

  expression values to use

- reverse_log_scale:

  reverse expression values from log scale

- logbase:

  log base to use if reverse_log_scale = TRUE

- top_percentage:

  percentage of cells that will be considered to have gene expression
  with matrix binarization

- output_enrichment:

  how to return enrichment output

- p_value:

  calculate p-values (boolean, default = FALSE)

- name:

  to give to spatial enrichment results, default = hypergeometric

- return_gobject:

  return giotto object

## Value

data.table with enrichment results

## Details

The enrichment score is calculated based on the p-value from the
hypergeometric test, -log10(p-value).

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

runHyperGeometricEnrich(gobject = g, sign_matrix = sign_matrix)
```
