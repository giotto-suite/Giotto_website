# Hypergeometric feature signature enrichment

Score each spatial position against cell type or process signatures with
a hypergeometric test. Each cell's most highly expressed features are
binarized, and each signature is tested for over-representation among
them.

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

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- sign_matrix:

  binary matrix of signature features (rows) by cell type or process
  (columns), 1 where the feature marks the type. Build one with
  [`makeSignMatrixPAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)
  or
  [`makeSignMatrixRank`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md).

- expression_values:

  character. Which expression values to use, e.g. "normalized". A
  method's own default is shown in its Usage section.

- reverse_log_scale:

  logical. Undo a log transform before averaging (default = TRUE).

- logbase:

  numeric. Log base to undo when `reverse_log_scale = TRUE` (default =
  2).

- top_percentage:

  percentage of features per cell treated as expressed when binarizing
  (default = 5)

- output_enrichment:

  character. "original" (default) or "zscore", which standardizes the
  scores within each cell type.

- p_value:

  logical. Calculate p-values (default = FALSE).

- name:

  character. Name to store the result under in the giotto object's
  spatial enrichment slot. `NULL` (default) uses the method's own name –
  see the Usage section.

- return_gobject:

  logical. Return the giotto object with the result added (default =
  TRUE), or the result object on its own.

## Value

data.table with enrichment results

## Details

The enrichment score is calculated based on the p-value from the
hypergeometric test, -log10(p-value).

## See also

Other feature set enrichment:
[`enrich_hyper`](https://giottosuite.com/dev/reference/enrich_hyper.md),
[`enrich_page`](https://giottosuite.com/dev/reference/enrich_page.md),
[`enrich_param`](https://giottosuite.com/dev/reference/enrich_param.md),
[`enrich_rank`](https://giottosuite.com/dev/reference/enrich_rank.md),
[`enrichment_PAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md),
[`makeSignMatrixRank()`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md),
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md),
[`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)

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
