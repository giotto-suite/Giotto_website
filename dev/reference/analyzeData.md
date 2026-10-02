# Data Analysis via Parameter Dispatch

Compute statistics or scores from matrix-type data. \`analyzeData()\` is
a generic that dispatches on both \`x\` (the data) and \`param\` (the
analysis operation). Methods return a \`data.table\` of computed values;
any downstream thresholding or selection is a separate step.

## Usage

``` r
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

## Value

a \`data.table\` of computed values
