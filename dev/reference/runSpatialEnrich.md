# Feature signature enrichment, any method

Score each spatial position against cell type or process signatures,
dispatching to one of the three enrichment methods. A thin router: every
argument is forwarded to the chosen method, and the result is whatever
that method returns.

## Usage

``` r
runSpatialEnrich(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  enrich_method = c("PAGE", "rank", "hypergeometric"),
  sign_matrix,
  expression_values = c("normalized", "scaled", "custom"),
  min_overlap_genes = 5,
  reverse_log_scale = TRUE,
  logbase = 2,
  p_value = FALSE,
  n_times = 1000,
  rbp_p = 0.99,
  num_agg = 100,
  max_block = 2e+07,
  top_percentage = 5,
  output_enrichment = c("original", "zscore"),
  name = NULL,
  verbose = TRUE,
  include_depletion = FALSE,
  ties_method = c("average", "max"),
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

- enrich_method:

  method for gene signature enrichment calculation

- sign_matrix:

  binary matrix of signature features (rows) by cell type or process
  (columns), 1 where the feature marks the type. Build one with
  [`makeSignMatrixPAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)
  or
  [`makeSignMatrixRank`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md).

- expression_values:

  character. Which expression values to use, e.g. "normalized". A
  method's own default is shown in its Usage section.

- min_overlap_genes:

  minimum number of overlapping features in `sign_matrix` required to
  calculate enrichment (PAGE)

- reverse_log_scale:

  logical. Undo a log transform before averaging (default = TRUE).

- logbase:

  numeric. Log base to undo when `reverse_log_scale = TRUE` (default =
  2).

- p_value:

  logical. Calculate p-values (default = FALSE).

- n_times:

  (page/rank) number of permutation iterations to calculate p-value

- rbp_p:

  (rank) fractional binarization threshold (default = 0.99)

- num_agg:

  (rank) number of top genes to aggregate (default = 100)

- max_block:

  number of lines to process together (default = 20e6)

- top_percentage:

  (hyper) percentage of features per cell treated as expressed when
  binarizing (default = 5)

- output_enrichment:

  character. "original" (default) or "zscore", which standardizes the
  scores within each cell type.

- name:

  character. Name to store the result under in the giotto object's
  spatial enrichment slot. `NULL` (default) uses the method's own name –
  see the Usage section.

- verbose:

  be verbose

- include_depletion:

  (PAGE) also test for depletion, not enrichment only (default = FALSE)

- ties_method:

  (rank) how to rank tied expression values, `"average"` (default) or
  `"max"`

- return_gobject:

  logical. Return the giotto object with the result added (default =
  TRUE), or the result object on its own.

## Value

Giotto object or enrichment results if return_gobject = FALSE

## Details

For details see the individual functions:

- **PAGE:**
  [`runPAGEEnrich`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)

- **Rank:**
  [`runRankEnrich`](https://giottosuite.com/dev/reference/runRankEnrich.md)

- **Hypergeometric:**
  [`runHyperGeometricEnrich`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md)

`reverse_log_scale` and `logbase` are ignored when
`enrich_method = "rank"`, and passing either warns. See
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md).

## See also

Other feature set enrichment:
[`enrich_hyper`](https://giottosuite.com/dev/reference/enrich_hyper.md),
[`enrich_page`](https://giottosuite.com/dev/reference/enrich_page.md),
[`enrich_param`](https://giottosuite.com/dev/reference/enrich_param.md),
[`enrich_rank`](https://giottosuite.com/dev/reference/enrich_rank.md),
[`enrichment_PAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md),
[`makeSignMatrixRank()`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md),
[`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md),
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md)

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

runSpatialEnrich(gobject = g, sign_matrix = sign_matrix)
```
