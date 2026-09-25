# PAGE enrichment

PAGE enrichment

PAGE enrichment

## Usage

``` r
# S4 method for class 'ANY,pageEnrichParam'
analyzeData(x, param, ..., sign_matrix)
```

## Arguments

- x:

  expression values. A `matrix`, a `Matrix`, or anything an engine
  registered against
  [pageEnrichParam](https://giottosuite.com/dev/reference/enrich_param.md)
  accepts.

- param:

  a
  [pageEnrichParam](https://giottosuite.com/dev/reference/enrich_param.md).

- ...:

  unused. Declared because
  [`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
  carries it, so an engine registered from another package can accept
  its own arguments.

- sign_matrix:

  binary matrix of signature features (rows) by cell type or process
  (columns), 1 where the feature marks the type. Build one with
  [`makeSignMatrixPAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)
  or
  [`makeSignMatrixRank`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md).

## Value

a `data.table` of `cell_ID` and one column per cell type

a `data.table` of `cell_ID` and one column per cell type

## See also

Other feature set enrichment:
[`enrich_hyper`](https://giottosuite.com/dev/reference/enrich_hyper.md),
[`enrich_param`](https://giottosuite.com/dev/reference/enrich_param.md),
[`enrich_rank`](https://giottosuite.com/dev/reference/enrich_rank.md),
[`enrichment_PAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md),
[`makeSignMatrixRank()`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md),
[`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md),
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md),
[`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
expr <- GiottoClass::getExpression(g, values = "normalized",
                                   output = "matrix")
feats <- rownames(expr)
sm <- makeSignMatrixPAGE(
    sign_names = c("typeA", "typeB"),
    sign_list = list(feats[1:150], feats[151:300])
)

# the verb runs on a bare matrix, with no giotto object involved
res <- analyzeData(expr, enrichParam("PAGE"), sign_matrix = sm)
head(res)
```
