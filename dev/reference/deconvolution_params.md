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

  numeric. Number of cells per spot (default = 50).

- cutoff:

  numeric. Expression cutoff below which a value is treated as absent
  (default = 2).

## Value

cell type proportions, one row per cell, summing to 1
