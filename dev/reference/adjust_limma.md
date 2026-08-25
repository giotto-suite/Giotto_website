# Limma Batch Correction

Batch effect removal via
[`limma::removeBatchEffect()`](https://rdrr.io/pkg/limma/man/removeBatchEffect.html)

## Value

limmaAdjustParam

## params

|  |  |
|----|----|
| `batch_columns` | [svkey](https://giotto-suite.github.io/GiottoClass/reference/spatValues.html) (optional) Up to two columns of information from a Giotto object with information indicating batches to remove the effects of. |
| `covariate_columns` | [svkey](https://giotto-suite.github.io/GiottoClass/reference/spatValues.html) (optional) Columns of information from a Giotto object with information indicating covariates to regress out. |

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

## Examples

``` r
limma <- adjustParam("limma")
limma$covariate_columns <- svkey(feats = c("nr_feats", "total_expr"))

g <- GiottoData::loadGiottoMini("visium")
processExpression(g, limma, name = "limma")
```
