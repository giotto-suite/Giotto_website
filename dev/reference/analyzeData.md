# Data Analysis via Parameter Dispatch

Compute statistics or scores from matrix-type data. \`analyzeData()\` is
a generic that dispatches on both \`x\` (the data) and \`param\` (the
analysis operation). Methods return a \`data.table\` of computed values;
any downstream thresholding or selection is a separate step.

## Usage

``` r
# S4 method for class 'exprObj,analyzeParam'
analyzeData(x, param, ...)

# S4 method for class 'allMatrix,featStatsParam'
analyzeData(x, param, ..., groups = NULL, stats = NULL)

# S4 method for class 'allMatrix,cellStatsParam'
analyzeData(x, param, ...)

# S4 method for class 'allMatrix,covGroupsParam'
analyzeData(x, param, ...)

# S4 method for class 'allMatrix,covLoessParam'
analyzeData(x, param, ...)

# S4 method for class 'allMatrix,varParam'
analyzeData(x, param, ...)
```

## Arguments

- x:

  data to analyze

- param:

  an \[analyzeParam-class\] inheriting object defining the analysis
  operation and its settings

- ...:

  additional params passed to specific methods

- groups:

  optional vector of group assignments, one per column of \`x\`, \`NA\`
  to exclude. When supplied, the statistics are taken per (feature,
  group) instead of over every cell, and the result gains \`group\` and
  \`n_cells\` columns.

- stats:

  optional character vector of accumulators to compute, any of
  \`"sum"\`, \`"sumsq"\`, \`"nnz"\`, \`"sum_det"\`. Grouped path only;
  emitted columns are whichever the requested accumulators support.

## Value

a \`data.table\` of computed values
