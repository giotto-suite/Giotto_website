# Sign-matrix enrichment params

Parameter objects for the sign-matrix spatial enrichment methods. Pass
one to
[`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
together with a sign matrix, or use the
[`runPAGEEnrich()`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)
/
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md)
/
[`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md)
wrappers, which build the param for you.

Each method has its own factory because their parameters do not overlap:
`min_overlap_genes`, `include_depletion` and `max_block` are PAGE-only,
`ties_method`, `rbp_p` and `num_agg` are rank-only, and `top_percentage`
is hypergeometric-only. A single flat signature would accept all of them
for every method and silently ignore the inapplicable ones, which is the
behaviour this replaces.

## Usage

``` r
enrichParam(method = "PAGE", ...)
```

## Arguments

- method:

  character. `"PAGE"`, `"rank"` or `"hypergeometric"`.

- ...:

  method-specific parameters; see Details.

## Value

an enrichParam-inheriting object

## Details

Shared by all three:

- `reverse_log_scale`:

  logical. undo a log transform before averaging (default `TRUE`).

- `logbase`:

  numeric. base for `reverse_log_scale` (default 2).

- `output_enrichment`:

  `"original"` (default) or `"zscore"`.

- `p_value`:

  logical. return p-values instead of scores.

PAGE: `min_overlap_genes` (5), `include_depletion` (`FALSE`), `n_times`
(1000), `max_block` (2e7), `verbose` (`TRUE`).

rank: `ties_method` (`"average"`), `n_times` (1000), `rbp_p` (0.99),
`num_agg` (100).

hypergeometric: `top_percentage` (5).

## See also

[analyze_param](https://giottosuite.com/dev/reference/analyze_param.md),
[`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)

Other feature set enrichment:
[`enrich_hyper`](https://giottosuite.com/dev/reference/enrich_hyper.md),
[`enrich_page`](https://giottosuite.com/dev/reference/enrich_page.md),
[`enrich_rank`](https://giottosuite.com/dev/reference/enrich_rank.md),
[`enrichment_PAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md),
[`makeSignMatrixRank()`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md),
[`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md),
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md),
[`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)

## Examples

``` r
p <- enrichParam("PAGE", min_overlap_genes = 10)
p$min_overlap_genes
```
