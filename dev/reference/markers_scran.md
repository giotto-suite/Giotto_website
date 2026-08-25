# Pairwise Marker Detection (scran)

Detect marker features by comparing each group against the others, as
implemented by
[`findMarkers`](https://rdrr.io/pkg/scran/man/findMarkers.html).

Every ordered pair of groups is tested, and the resulting p-values are
combined into a single ranked table per group. With the default
`test_type = "t"` the test is a Welch \\t\\-test on the per-group
moments:

\$\$\LARGE t = \frac{\bar{x}\_{i,a} - \bar{x}\_{i,b}}
{\sqrt{s^2\_{i,a}/n_a + s^2\_{i,b}/n_b}} \$\$ Where:

- (\\\bar{x}\_{i,a}\\) is the mean of feature \\i\\ over the cells of
  group \\a\\

- (\\s^2\_{i,a}\\) is the variance of feature \\i\\ over the same cells

- (\\n_a\\) is the number of cells in group \\a\\

Because the statistic depends on the values only through \\n\\,
\\\bar{x}\\ and \\s^2\\, the expression matrix is visited once per
analysis rather than once per comparison. That is what lets a streaming
backend implement the same test without materializing the matrix.

Which expression values are tested is the caller's choice — the methods
use whatever matrix they are given.

## Usage

``` r
# S4 method for class 'matrix,scranMarkersParam'
analyzeData(x, param, ..., groups = NULL)

# S4 method for class 'Matrix,scranMarkersParam'
analyzeData(x, param, ..., groups = NULL)

# S4 method for class 'DelayedMatrix,scranMarkersParam'
analyzeData(x, param, ..., groups = NULL)
```

## Arguments

- x:

  expression values. A \`matrix\`, a \`Matrix\`, or a \`DelayedMatrix\`
  (which is what \`expression_values = "scaled"\` holds).

- param:

  a \[scranMarkersParam-class\].

- groups:

  vector of group assignments, one per cell. Taken in column order of
  \`x\`, unless the vector is named by cell ID, in which case it is
  matched to \`colnames(x)\`. Naming is the safer form: the expression
  matrix and the cell metadata a caller builds \`groups\` from are
  fetched independently and need not share a cell order.

## Value

marker detection results

## params

|  |  |
|----|----|
| `test_type` | character (default = "t"). Pairwise test: `"t"` Welch \\t\\-test, `"wilcox"` rank-sum, `"binom"` binomial on detection rates. Backends may support only a subset. |
| `pval_type` | character (default = "any"). How the pairwise p-values are combined per group: `"any"`, `"some"`, `"all"`. |
| `comparison` | character (default = "pairwise"). `"pairwise"` tests every ordered pair; `"one_vs_rest"` tests each group against the pooled remainder. |
| `direction` | character (default = "any"). `"any"`, `"up"`, `"down"`. |
| `lfc` | numeric (default = 0). Log-fold-change threshold to test against. |
| `std_lfc` | logical (default = FALSE). Report the effect size as a standardized log-fold-change (Cohen's d). |
| `min_prop` | numeric or NULL. Minimum proportion of comparisons a feature must be significant in, for `pval_type = "some"`. |
| `log_p` | logical (default = FALSE). Report p-values on the log scale. |
| `full_stats` | logical (default = FALSE). Retain the per-comparison statistics as nested columns. |
| `sorted` | logical (default = TRUE). Sort each group's table by significance. |

`pval_type` and `min_prop` describe how scran combines the pairwise
comparisons and have no meaning independent of it; see
[`findMarkers`](https://rdrr.io/pkg/scran/man/findMarkers.html).

## See also

[analyze_param](https://giottosuite.com/dev/reference/analyze_param.md),
[`markersParam()`](https://giottosuite.com/dev/reference/analyze_param.md),
[`findScranMarkers()`](https://giottosuite.com/dev/reference/findScranMarkers.md)

Other marker detection parameters:
[`markers_gini`](https://giottosuite.com/dev/reference/markers_gini.md)
