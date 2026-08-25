# Value MinMax Restriction/Clamping

Set an `upper` and `lower` bound for the data. Values above `upper` will
be set to the `upper` value. Values below `lower` will be set to the
`lower` value.

## Value

minmaxThreshParam

## params

|  |  |
|----|----|
| `upper` | numeric (default = Inf) highest acceptable value. Values above this will be set to the same as `upper`. |
| `lower` | numeric (default = -Inf) lowest acceptable value. Values below this will be set to the same as `lower`. |
| `values` | logical (`SpatRaster` only) If `FALSE` values outside the clamping range become `NA`, if `TRUE`, they get the extreme values |

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other threshold parameters:
[`threshold_binarize`](https://giottosuite.com/dev/reference/threshold_binarize.md)

## Examples

``` r
e <- GiottoData::loadSubObjectMini("exprObj")
# also works with matrix classes
max_e <- processData(e, thresholdParam("minmax", upper = 6))
force(max_e)

gimg <- GiottoData::loadSubObjectMini("giottoLargeImage")
# also works with SpatRasters
mm_img <- processData(gimg,
    thresholdParam("minmax", lower = 30, upper = 100)
)
plot(mm_img)
```
