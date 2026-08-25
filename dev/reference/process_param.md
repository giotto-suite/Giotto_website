# Data Processing Parameter Classes

Data processing operations in Giotto Suite can be divided into
normalization, scaling, and adjustments. These operations can be
selected via the factory functions `normParam()`, `scaleParam()`, and
`adjustParam()`, respectively.

Requested operations are generated as method-specific param classes that
contain all the parameters needed to perform them, editable through
`$<-`.

## Usage

``` r
normParam(method = "default", ...)

scaleParam(method = "default", ...)

adjustParam(method = "limma", ...)

thresholdParam(method = "binarize", ...)
```

## Arguments

- method:

  character. Name of method to use. See details.

- ...:

  (optional) Additional named parameters relevant to the param class.

## Details

Generated params are S4 objects inheriting from `processParam` and one
of `normParam`, `scaleParam`, and `adjustParam`.

## normParam methods

- [`"default"`](https://giottosuite.com/dev/reference/norm_default.md) -
  default Giotto normalizations steps (library + log norms)

- [`"library"`](https://giottosuite.com/dev/reference/norm_library.md) -
  library normalization

- [`"log"`](https://giottosuite.com/dev/reference/norm_log.md) - log
  normalization

- [`"osmfish"`](https://giottosuite.com/dev/reference/norm_osmfish.md) -
  osmfish normalization method

- [`"pearson"`](https://giottosuite.com/dev/reference/norm_pearson.md) -
  Lause/Kobak 2020 pearson residuals normalization

- [`"quantile"`](https://giottosuite.com/dev/reference/norm_quantile.md) -
  quantile normalization

- [`"tf-idf"`](https://giottosuite.com/dev/reference/norm_tfidf.md) -
  Term Frequency-Inverse Document Frequency

- [`"l2"`](https://giottosuite.com/dev/reference/norm_l2.md) - L2
  normalization (also known as Euclidean normalization)

- [`"arcsinh"`](https://giottosuite.com/dev/reference/norm_arcsinh.md) -
  arcsinh transformation

## scaleParam methods

- [`"default"`](https://giottosuite.com/dev/reference/scale_default.md) -
  default Giotto scaling steps (scale along features then cells)

- [`"zscore"`](https://giottosuite.com/dev/reference/scale_zscore.md) -
  essentially the same as
  [`base::scale()`](https://rdrr.io/r/base/scale.html), but with a
  `MARGIN` param allowing scaling long either cols or rows

## adjustParam methods

- [`"limma"`](https://giottosuite.com/dev/reference/adjust_limma.md) -
  limma batch correction

## thresholdParam methods

- [`"binarize"`](https://giottosuite.com/dev/reference/threshold_binarize.md) -
  data binarization (matrices and rasters)

- [`"minmax"`](https://giottosuite.com/dev/reference/threshold_minmax.md) -
  value restriction/clamping (matrices and rasters)

## See also

[`processData()`](https://giottosuite.com/dev/reference/processData.md)
for the generic used to apply these params

[`processExpression()`](https://giottosuite.com/dev/reference/processExpression.md)
for the way to use this framework with the `giotto` object
