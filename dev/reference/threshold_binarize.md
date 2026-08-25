# Data Binarization

Binarize values to 0 and 1 based on a minimal value. For matrices, the
default threshold is 0. For rasters, the default is a value determined
through sampled (5e5 pixels) otsu.

## Value

binarizeThreshParam

## params

|  |  |
|----|----|
| `threshold` | numeric (optional) Values above or equal to the threshold will be set to 1. Below will be set to 0. If not provided, defaults to 0 for matrices and a value determined by otsu for rasters. |
| `drop0` | logical (only for `dgCMatrix`, default = FALSE) Whether to run [Matrix::drop0](https://rdrr.io/pkg/Matrix/man/drop0.html) after binarization |

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other threshold parameters:
[`threshold_minmax`](https://giottosuite.com/dev/reference/threshold_minmax.md)

## Examples

``` r
e <- GiottoData::loadSubObjectMini("exprObj")
# also works with matrix classes
bin_e <- processData(e, thresholdParam("binarize"))
force(bin_e)

gimg <- GiottoData::loadSubObjectMini("giottoLargeImage")
# also works with SpatRasters
bin_img <- processData(gimg, thresholdParam("binarize"))
plot(bin_img)
```
