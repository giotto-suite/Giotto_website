# Estimate cell type proportions with spatialDWLS

Estimate what fraction of each spatial position is made up of each cell
type, given a mean-expression reference from single-cell data. Unlike
the enrichment methods, which return unbounded scores, this returns a
composition: the values for a position sum to one.

## Usage

``` r
runDWLSDeconv(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
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

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- expression_values:

  character. Which expression values to use, e.g. "normalized". A
  method's own default is shown in its Usage section.

- logbase:

  numeric. Log base of the expression values (default = 2).

- cluster_column:

  character. Cell metadata column holding the cluster assignment used to
  group cells.

- sign_matrix:

  matrix of mean expression per cell type: signature features (rows) by
  cell type (columns). Build one with
  [`makeSignMatrixDWLS`](https://giottosuite.com/dev/reference/makeSignMatrixDWLS.md)
  or
  [`makeSignMatrixDWLSfromMatrix`](https://giottosuite.com/dev/reference/makeSignMatrixDWLSfromMatrix.md).
  This is not the binary matrix the enrichment methods take.

- n_cell:

  numeric. Number of cells per spot (default = 50).

- cutoff:

  numeric. Expression cutoff below which a value is treated as absent
  (default = 2).

- name:

  character. Name to store the result under in the giotto object's
  spatial enrichment slot. `NULL` (default) uses the method's own name –
  see the Usage section.

- return_gobject:

  logical. Return the giotto object with the result added (default =
  TRUE), or the result object on its own.

## Value

giotto object or deconvolution results

## See also

<https://github.com/dtsoucas/DWLS> for the *DWLS* bulk deconvolution
method, and
[doi:10.1186/s13059-021-02362-7](https://doi.org/10.1186/s13059-021-02362-7)
for *spatialDWLS*, the spatial implementation used here.

Other spatial deconvolution:
[`makeSignMatrixDWLS()`](https://giottosuite.com/dev/reference/makeSignMatrixDWLS.md),
[`makeSignMatrixDWLSfromMatrix()`](https://giottosuite.com/dev/reference/makeSignMatrixDWLSfromMatrix.md),
[`runSpatialDeconv()`](https://giottosuite.com/dev/reference/runSpatialDeconv.md)

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

runDWLSDeconv(gobject = g, sign_matrix = sign_matrix)
```
