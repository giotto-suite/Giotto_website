# Rank-based feature signature enrichment

Score each spatial position against cell type or process signatures
using a rank-biased-precision approach. Genes are ranked across cells
and those ranks are then ranked within each cell, so the score depends
on relative ordering rather than on absolute expression.

## Usage

``` r
runRankEnrich(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  sign_matrix,
  expression_values = c("normalized", "raw", "scaled", "custom"),
  reverse_log_scale = TRUE,
  logbase = 2,
  output_enrichment = c("original", "zscore"),
  ties_method = c("average", "max"),
  p_value = FALSE,
  n_times = 1000,
  rbp_p = 0.99,
  num_agg = 100,
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

  **\[deprecated\]** ignored; see Details.

- logbase:

  **\[deprecated\]** ignored; see Details.

- output_enrichment:

  character. "original" (default) or "zscore", which standardizes the
  scores within each cell type.

- ties_method:

  how to rank tied expression values, `"average"` (default) or `"max"`

- p_value:

  logical. Calculate p-values (default = FALSE).

- n_times:

  number of permutation iterations to calculate p-value

- rbp_p:

  fractional binarization threshold (default = 0.99)

- num_agg:

  number of top genes to aggregate (default = 100)

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

sign_matrix: a rank-fold matrix with genes as row names and cell-types
as column names. Alternatively a scRNA-seq matrix and vector with
clusters can be provided to makeSignMatrixRank, which will create the
matrix for you.  

First a new rank is calculated as R = (R1\*R2)^(1/2), where R1 is the
rank of fold-change for each gene in each spot and R2 is the rank of
each marker in each cell type. The Rank-Biased Precision is then
calculated as: RBP = (1 - 0.99) \* (0.99)^(R - 1) and the final
enrichment score is then calculated as the sum of top 100 RBPs.

`reverse_log_scale` and `logbase` are ignored, and cannot be made to
work: the statistic is a rank of a rank, and ranking is invariant to any
monotonic per-gene transform, so no value of either argument can move a
single rank. Use
[`runPAGEEnrich()`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)
or
[`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md)
if the reverse-log step needs to matter.

## See also

[`makeSignMatrixRank`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md)

Other feature set enrichment:
[`enrich_hyper`](https://giottosuite.com/dev/reference/enrich_hyper.md),
[`enrich_page`](https://giottosuite.com/dev/reference/enrich_page.md),
[`enrich_param`](https://giottosuite.com/dev/reference/enrich_param.md),
[`enrich_rank`](https://giottosuite.com/dev/reference/enrich_rank.md),
[`enrichment_PAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md),
[`makeSignMatrixRank()`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md),
[`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md),
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

runRankEnrich(
    gobject = g, sign_matrix = sign_matrix,
    expression_values = "normalized"
)
```
