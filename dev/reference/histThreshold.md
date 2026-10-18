# Threshold from a value histogram

The on/off threshold of one feature from the histogram of its values:
values above the returned threshold are on. Works on exact values (each
distinct value its own bin) and on binned values alike, so a backend
that holds the values and one that streams a binned histogram make the
same call.

## Usage

``` r
histThreshold(
  value,
  count,
  upper = value,
  method = c("kmeans", "rank"),
  percentage_rank = 30
)
```

## Arguments

- value:

  numeric. Representative value of each bin (its midpoint, or the value
  itself for an exact histogram), ascending. Zeros, stored or not,
  belong in a bin of their own with value 0.

- count:

  numeric. Number of values in each bin.

- upper:

  numeric. Upper edge of each bin; the threshold is always one of these.
  Defaults to \`value\`, which is right for an exact histogram.

- method:

  \`"kmeans"\`: the split that maximises the between-group sum of
  squares (exact 1-D 2-means; Otsu's method). \`"rank"\`: the top
  \`percentage_rank\` percent of values, ties at their average rank.

- percentage_rank:

  numeric. Percentage of values called on by \`method = "rank"\`.

## Value

numeric(1). \`Inf\` when nothing can be on (fewer than two non-empty
bins, or no value inside the rank cut); \`-Inf\` when everything is.

## Examples

``` r
histThreshold(c(0, 1, 2, 8, 9), c(10, 3, 2, 4, 1), method = "kmeans")
```
