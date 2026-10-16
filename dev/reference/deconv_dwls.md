# spatialDWLS deconvolution

The
[`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
method for a
[dwlsDeconvParam](https://giottosuite.com/dev/reference/deconv_param.md).
The computation is done by the spatialDWLS package
(`spatialDWLS::dwls()`), which is suggested rather than imported:
install it with `remotes::install_github("drieslab/spatialDWLS")`.

## Usage

``` r
# S4 method for class 'ANY,dwlsDeconvParam'
analyzeData(x, param, ..., sign_matrix, cell_clusters)
```

## Arguments

- x:

  expression values, log-scaled, features by spots. A `matrix`, a
  `Matrix`, or anything an engine registered against
  [dwlsDeconvParam](https://giottosuite.com/dev/reference/deconv_param.md)
  accepts.

- param:

  a
  [dwlsDeconvParam](https://giottosuite.com/dev/reference/deconv_param.md).

- ...:

  unused. Declared because
  [`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
  carries it, so an engine registered from another package can accept
  its own arguments.

- sign_matrix:

  matrix of mean expression per cell type: signature features (rows) by
  cell type (columns). Build one with
  [`makeSignMatrixDWLS`](https://giottosuite.com/dev/reference/makeSignMatrixDWLS.md)
  or
  [`makeSignMatrixDWLSfromMatrix`](https://giottosuite.com/dev/reference/makeSignMatrixDWLSfromMatrix.md).
  This is not the binary matrix the enrichment methods take.

- cell_clusters:

  cluster assignment of each spot. Either named by spot ID (matched
  against `colnames(x)`) or unnamed and in the same order as the columns
  of `x`.

## Value

a `data.table` of `cell_ID` and one proportion column per cell type.
Each solved spot sums to one; unsolvable spots are `NA` (or 0, see
`na_as_zero` in
[`deconvParam()`](https://giottosuite.com/dev/reference/deconv_param.md)).

## See also

Other spatial deconvolution:
[`deconv_param`](https://giottosuite.com/dev/reference/deconv_param.md),
[`makeSignMatrixDWLS()`](https://giottosuite.com/dev/reference/makeSignMatrixDWLS.md),
[`makeSignMatrixDWLSfromMatrix()`](https://giottosuite.com/dev/reference/makeSignMatrixDWLSfromMatrix.md),
[`runDWLSDeconv()`](https://giottosuite.com/dev/reference/runDWLSDeconv.md),
[`runSpatialDeconv()`](https://giottosuite.com/dev/reference/runSpatialDeconv.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
expr <- GiottoClass::getExpression(g, values = "normalized",
                                   output = "matrix")
md <- GiottoClass::pDataDT(g)
sm <- makeSignMatrixDWLS(g,
    sign_gene = rownames(expr)[1:100],
    cell_type_vector = as.character(md$leiden_clus)
)
clus <- stats::setNames(md$leiden_clus, md$cell_ID)

res <- analyzeData(expr, deconvParam("DWLS"),
    sign_matrix = sm, cell_clusters = clus)
head(res)
```
