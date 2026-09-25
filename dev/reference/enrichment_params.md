# Params documentation template: enrichment_params

Params documentation template: enrichment_params

## Arguments

- sign_matrix:

  binary matrix of signature features (rows) by cell type or process
  (columns), 1 where the feature marks the type. Build one with
  [`makeSignMatrixPAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)
  or
  [`makeSignMatrixRank`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md).

- reverse_log_scale:

  logical. Undo a log transform before averaging (default = TRUE).

- logbase:

  numeric. Log base to undo when `reverse_log_scale = TRUE` (default =
  2).

- output_enrichment:

  character. "original" (default) or "zscore", which standardizes the
  scores within each cell type.

- p_value:

  logical. Calculate p-values (default = FALSE).

## Value

spatial enrichment scores, one per cell per signature
