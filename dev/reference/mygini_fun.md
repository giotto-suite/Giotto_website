# mygini_fun

calculate gini coefficient

## Usage

``` r
mygini_fun(x, weights = rep(1, length(x)), min_length = 0)
```

## Arguments

- x:

  numeric vector to take the coefficient over

- weights:

  numeric vector of weights, one per entry of \`x\`

- min_length:

  pad \`x\` up to this length before computing, using copies of its own
  minimum. \`0\` (the default) never pads.

## Value

gini coefficient

## Details

A gini coefficient over \`n\` values cannot exceed \`(n - 1) / n\`, so
coefficients taken over vectors of different lengths are not on a common
scale — 0.50 is a perfect score over two values and a middling one over
twenty. \`min_length\` removes that dependence for short vectors by
padding them out with their own minimum, which raises the ceiling to
\`(min_length - 1) / min_length\` for anything shorter. Padded entries
carry weight 1.

This matters wherever the vector length is set by the data rather than
chosen: per-cluster marker scores are taken over one value per cluster,
so without padding the same feature scores differently depending on how
many clusters were compared.
