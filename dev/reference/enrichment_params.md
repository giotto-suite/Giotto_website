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

  logical. Also compute p-values, from the unscaled scores (default =
  FALSE). The `run*Enrich()` functions store them beside the scores as
  `<name>_p`, with Benjamini-Hochberg adjusted p-values over all cells
  and types as `<name>_padj`;
  [`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
  returns the p-values, carrying the scores as their `"scores"`
  attribute.

## Value

spatial enrichment scores, one per cell per signature
