# Data Processing Parameter Classes

Data processing operations in Giotto Suite can be divided into
normalization, scaling, and adjustments. These operations can be
selected via the factory functions `normParam()`, `scaleParam()`, and
`adjustParam()`, respectively.

Requested operations are generated as method-specific param classes that
contain all the parameters needed to perform them, editable through
`$<-`.

Construct a \`filterParam\` carrying the cell + feature filter
thresholds used by \[filterGiotto()\]. \`filterGiotto\` builds this
internally; direct use is only needed when computing masks on a
standalone matrix.

Returns a \`list(feats_keep, cells_keep)\` of character ID vectors when
passed to \[filterData()\].

Construct a \`pcaParam\` for use with \[reduceData()\]. \`runPCA()\`
builds these internally; direct use is only needed when computing PCA on
a standalone matrix.

Returns a list with \`u\`, \`d\`, \`v\`, and \`sdev\` when passed to
\`reduceData()\`.

## Usage

``` r
normParam(method = "default", ...)

scaleParam(method = "default", ...)

adjustParam(method = "limma", ...)

thresholdParam(method = "binarize", ...)

filterParam(
  method = "default",
  expression_threshold = 1,
  feat_det_in_min_cells = 100,
  min_det_feats_per_cell = 100,
  ...
)

pcaParam(
  method = c("auto", "random", "irlba", "exact"),
  ncp = 50L,
  center = TRUE,
  scale = TRUE,
  feats_to_use = NULL,
  n_oversamples = 10L,
  n_power_iter = 2L,
  set_seed = TRUE,
  seed_number = 1234L,
  dry_run = FALSE,
  ...
)
```

## Arguments

- method:

  one of \`"auto"\`, \`"random"\`, \`"irlba"\`, \`"exact"\`. \`"auto"\`
  defers the choice to the substrate: in-memory backends resolve to
  \`"irlba"\`; streaming backends (\`parquetExprStore\` in GiottoDisk)
  resolve to \`"random"\` / \`"gram-eigen"\` per their own heuristics.

- ...:

  (optional) Additional named parameters relevant to the param class.

- expression_threshold:

  numeric. A value \`\>= expression_threshold\` counts as detected.
  Default \`1\`.

- feat_det_in_min_cells:

  integer. Keep features detected in at least this many cells. Default
  \`100\`.

- min_det_feats_per_cell:

  integer. Keep cells with at least this many detected features (counted
  only over kept features — Giotto's two-stage convention). Default
  \`100\`.

- ncp:

  number of components. Default \`50\`.

- center:

  logical. Center columns. Default \`TRUE\`.

- scale:

  logical. Scale columns by SD. Default \`TRUE\`. Streaming backends
  (parquetExprStore) ignore this — scaling densifies the matrix and is
  incompatible with O(N\*k) streaming.

- feats_to_use:

  character vector of feature IDs to subset to before PCA. \`NULL\`
  means all features. Useful for HVG selection.

- n_oversamples:

  integer. Halko oversampling parameter for \`random\`. Default \`10\`.

- n_power_iter:

  integer. Halko power iterations for \`random\`. Default \`2\`.

- set_seed:

  logical. Default \`TRUE\`.

- seed_number:

  integer. Default \`1234\`.

- dry_run:

  logical. Only meaningful when \`method = "auto"\`. When \`TRUE\`,
  \`reduceData(x, param)\` returns the substrate-resolved concrete
  \`pcaParam\` instead of running PCA. Useful for inspecting or testing
  the substrate's method selection. Default \`FALSE\`.

- ...:

  reserved.

## Value

A \`defaultFilterParam\` object.

Concrete \`pcaParam\` subclass object.

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

## Examples

``` r
p <- filterParam(expression_threshold = 1,
                  feat_det_in_min_cells = 5,
                  min_det_feats_per_cell = 3)
p <- pcaParam("random", ncp = 30)
p_auto <- pcaParam("auto", ncp = 30)  # substrate picks the flavor
# Inspect the substrate's choice without running PCA:
# reduceData(x, pcaParam("auto", dry_run = TRUE))
```
