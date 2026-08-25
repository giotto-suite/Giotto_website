# Composable Data Processing

Perform data transformations, or set up chains of transformations and
operations to be applied to matrix type data. `processData()` is a
generic for which methods can be defined off both `x` (the data to
transform), and `param` (the transform operation).

## Usage

``` r
# S4 method for class 'giottoLargeImage,list'
processData(x, param, name = NULL, ...)

# S4 method for class 'giottoLargeImage,processParam'
processData(x, param, name = NULL, ...)

# S4 method for class 'exprObj,list'
processData(x, param, name = "scaled", ...)

# S4 method for class 'exprObj,normParam'
processData(x, param, name = "normalized", ...)

# S4 method for class 'exprObj,scaleParam'
processData(x, param, name = "scaled", ...)

# S4 method for class 'exprObj,adjustParam'
processData(x, param, name = "custom", ...)

# S4 method for class 'SpatRaster,list'
processData(x, param, ...)

# S4 method for class 'allMatrix,list'
processData(x, param, ...)
```

## Arguments

- x:

  data to transform

- param:

  S4 parameter class defining the transform operation and params
  affecting it. Can also be a list of several of these objects, acting
  as a pipeline.

- name:

  character (optional). [Object
  name](https://giotto-suite.github.io/GiottoClass/reference/giotto_schema.html)
  to assign to the output. Default `name` changes based on `param`
  input:

  - when `param` is `list` or `scaleParam`: `name = "scaled"`

  - when `param` is `normParam`: `name = "normalized"`

  - when `param` is `adjustParam`: `name = "custom"`

  - when `param` is `osmFISHNormParam`: `name = "custom"`

  - when `param` is `pearsonResidNormParam`: `name = "scaled"`

- ...:

  additional params to pass

## Value

The same class as `x`

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)
for processing operations that can be performed through `processData()`

[`processExpression()`](https://giottosuite.com/dev/reference/processExpression.md)
for the way to use this framework with the `giotto` object

## Examples

``` r
m <- matrix(c(0, 0, 3, 2, 0, 5, 4, 0, 0, 1, 12, 0), nrow = 3)

# single operation
lib_norm <- normParam("library")
lib_norm$scalefactor <- 5000 # alter a default param of library norm
processData(m, lib_norm)

# chained operations
log_norm <- normParam("log")
zscore_rows <- scaleParam("zscore", MARGIN = 1)
zscore_cols <- scaleParam("zscore")
# this is essentially the same as the default giotto normalization
# only difference is the library norm scalefactor change.
processData(m, list(lib_norm, log_norm, zscore_rows, zscore_cols))
```
