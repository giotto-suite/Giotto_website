# Params documentation template: enrichment_params

Params documentation template: enrichment_params

## Arguments

- sign_matrix:

  matrix of signature features (rows) by cell type or process (columns);
  a feature marks a type where its value is \> 0. Build one with
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

  logical. Return p-values instead of scores (default = FALSE). They are
  computed from the unscaled scores, so `output_enrichment` applies to
  scores only.

## Value

spatial enrichment scores, one per cell per signature
