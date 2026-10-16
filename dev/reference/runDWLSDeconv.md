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
  return_gobject = TRUE,
  na_as_zero = FALSE,
  BPPARAM = NULL
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

  numeric. Expected number of cells per spot (default = 50). In the
  second round a cell type is kept for a spot only when its first-round
  proportion is at least `1 / n_cell`.

- cutoff:

  numeric. PAGE enrichment z-score a cell type must reach in at least
  one spot of a cluster to be a candidate for that cluster (default =
  2). The two highest-scoring types are always candidates.

- name:

  character. Name to store the result under in the giotto object's
  spatial enrichment slot. `NULL` (default) uses the method's own name –
  see the Usage section.

- return_gobject:

  logical. Return the giotto object with the result added (default =
  TRUE), or the result object on its own.

- na_as_zero:

  logical. Positions with no signal on the signature features cannot be
  solved and are `NA` by default; `TRUE` returns them as 0 instead.

- BPPARAM:

  a `BiocParallelParam` used for the per-position solves. `NULL`
  (default) uses `getOption("giotto.bpparam")` when that is a parallel
  param and runs serially otherwise.

## Value

giotto object or deconvolution results

## Details

The work is done by
[`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
with a
[`deconvParam()`](https://giottosuite.com/dev/reference/deconv_param.md),
dispatched on the expression object, so a disk-backed expression store
can supply its own streaming implementation.

## See also

<https://github.com/dtsoucas/DWLS> for the *DWLS* bulk deconvolution
method, and
[doi:10.1186/s13059-021-02362-7](https://doi.org/10.1186/s13059-021-02362-7)
for *spatialDWLS*, the spatial implementation used here.

Other spatial deconvolution:
[`deconv_dwls`](https://giottosuite.com/dev/reference/deconv_dwls.md),
[`deconv_param`](https://giottosuite.com/dev/reference/deconv_param.md),
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
