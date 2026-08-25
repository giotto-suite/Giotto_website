# Create recovery plot

Plots recovery plot to compare ligand-receptor rankings from spatial and
expression information

## Usage

``` r
.plotRecovery_sub(
  combCC,
  first_col = "LR_expr_rnk",
  second_col = "LR_spat_rnk"
)
```

## Arguments

- combCC:

  combined communinication scores from
  [`combCCcom`](https://giottosuite.com/dev/reference/combCCcom.md)

- first_col:

  first column to use

- second_col:

  second column to use

## Value

ggplot
