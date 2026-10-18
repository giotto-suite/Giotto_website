# Data Binarization

Binarize values to 0 and 1 based on a minimal value. For matrices, the
default threshold is 0. For rasters, the default is a value determined
through sampled (5e5 pixels) otsu.

For matrices the threshold can also differ per feature (row): give one
value per row, or a rule that picks each row's threshold from its
values. Rules see a feature's zeros, stored or not:

- `"kmeans"` — the split minimising the within-group sum of squares
  (exact 1-D 2-means, the Otsu split), see
  [`histThreshold()`](https://giottosuite.com/dev/reference/histThreshold.md).

- `"rank"` — the top `percentage_rank` percent of cells by value, ties
  at their average rank.

## Value

binarizeThreshParam

## params

|  |  |
|----|----|
| `threshold` | numeric or character (optional) Values above the threshold will be set to 1 (rasters: above or equal). Below will be set to 0. One value, one value per row, or `"kmeans"` / `"rank"`. If not provided, defaults to 0 for matrices and a value determined by otsu for rasters (which is also what `"kmeans"` means for a raster). |
| `percentage_rank` | numeric (default = 30) percentage of cells called on per feature by `threshold = "rank"` |
| `n_bins` | integer (default = 1024) histogram bins per feature for backends that stream values instead of holding them |
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
