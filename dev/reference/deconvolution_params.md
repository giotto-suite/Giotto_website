# Params documentation template: deconvolution_params

Params documentation template: deconvolution_params

## Arguments

- sign_matrix:

  matrix of mean expression per cell type: signature features (rows) by
  cell type (columns). Build one with
  [`makeSignMatrixDWLS`](https://giottosuite.com/dev/reference/makeSignMatrixDWLS.md)
  or
  [`makeSignMatrixDWLSfromMatrix`](https://giottosuite.com/dev/reference/makeSignMatrixDWLSfromMatrix.md).
  This is not the binary matrix the enrichment methods take.

- logbase:

  numeric. Log base of the expression values (default = 2).

- cluster_column:

  character. Cell metadata column holding the cluster assignment used to
  group cells.

- n_cell:

  numeric. Expected number of cells per spot (default = 50). In the
  second round a cell type is kept for a spot only when its first-round
  proportion is at least `1 / n_cell`.

- cutoff:

  numeric. PAGE enrichment z-score a cell type must reach in at least
  one spot of a cluster to be a candidate for that cluster (default =
  2). The two highest-scoring types are always candidates.

## Value

cell type proportions, one row per cell, summing to 1
