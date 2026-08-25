# Expression Data Processing

Perform data transformations, or set up chains of transformations and
operations to be applied to expression type data in the `giotto` object.

## Usage

``` r
processExpression(
  gobject,
  param,
  name = NULL,
  expression_values = "raw",
  spat_unit = NULL,
  feat_type = NULL,
  return_gobject = TRUE,
  ...
)
```

## Arguments

- gobject:

  `giotto` object

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

- expression_values:

  character. Name of matrix to use

- spat_unit:

  character (optional). spatial unit to use

- feat_type:

  character (optional). feature type to use

- return_gobject:

  logical (optional). Whether to return the `gobject`. When FALSE, the
  `exprObj` is returned instead.

- ...:

  additional params to pass

## Value

A `giotto` object when `return_gobject = TRUE`. Otherwise, an `exprObj`

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)
for processing operations that can be performed

[`processData()`](https://giottosuite.com/dev/reference/processData.md)
for the lower level generic handling these operations

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
# single operation
processExpression(g, normParam("library"), name = "library")

# single operation with changed parameter
lib <- normParam("library")
lib$scalefactor = 1000
processExpression(g, lib, name = "library2")

# return the exprObj instead
processExpression(g, lib, name = "library2", return_gobject = FALSE)

# chained operation (this is the Giotto standard normalization)
processExpression(g,
    list(
        normParam("library"),
        normParam("log"),
        scaleParam("zscore", MARGIN = 1),
        scaleParam("zscore", MARGIN = 2)
    ),
    name = "scaled2"
)
```
