# Specificity Marker Detection (gini)

Detect marker features by how unevenly a feature is distributed across
groups, using the Gini coefficient.

Two coefficients are taken per feature, over the per-group mean
expression and over the per-group detection fraction:

\$\$\LARGE G_i = \frac{\sum\_{a}\sum\_{b} \|v\_{i,a} - v\_{i,b}\|} {2
G^2 \bar{v}\_i} \$\$ Where:

- (\\v\_{i,a}\\) is the statistic for feature \\i\\ in group \\a\\ —
  mean expression for `expression_gini`, detection fraction for
  `detection_gini`

- (\\G\\) is the number of groups

The statistic depends on the values only through the per-(feature,
group) mean and detection fraction, so the expression matrix is visited
once regardless of how many groups there are. That is what lets a
streaming backend supply gini markers with no code of its own — the pass
is
[featStatsParam](https://giottosuite.com/dev/reference/analyze_param.md),
and this method consumes its output.

Gini is **scale-free**: a 0.001 vs 0.0001 difference between groups
scores identically to 100 vs 10. It therefore carries no magnitude term
and will rank near-noise features as perfectly specific, which is what
`min_expression` and `min_detection` exist to prevent. Its ceiling is
\\(G-1)/G\\, so a fixed `min_expression_gini` is not comparable across
runs with different group counts unless `min_length` is set.

Which expression values are scored is the caller's choice — the method
uses whatever matrix it is given.

## Usage

``` r
# S4 method for class 'ANY,giniMarkersParam'
analyzeData(x, param, ..., groups = NULL, verbose = TRUE)
```

## Arguments

- x:

  expression values — anything \`analyzeData(x, featStatsParam)\`
  accepts, including a \`matrix\`, a \`Matrix\`, a \`DelayedMatrix\`
  (what \`expression_values = "scaled"\` holds) or a disk-backed store.

- param:

  a \[giniMarkersParam-class\].

- groups:

  vector of group assignments, one per cell. Taken in column order of
  \`x\`, unless the vector is named by cell ID, in which case it is
  matched on identity. Naming is the safer form: the expression matrix
  and the cell metadata a caller builds \`groups\` from are fetched
  independently and need not share a cell order. \`NA\` excludes a cell
  from every group, which is how a caller narrows to a subset without
  copying the object.

- verbose:

  report progress per group. \`"one_vs_rest"\` only.

## Value

marker detection results

## params

|  |  |
|----|----|
| `comparison` | character (default = "pairwise"). `"pairwise"` scores every group against the others at once; `"one_vs_rest"` scores each group against the pooled remainder, one table per group. |
| `min_expression` | numeric (default = 0.2). Minimum per-group mean expression, gating the `expression` column. |
| `min_detection` | numeric (default = 0.2). Minimum fraction of a group's cells above `detection_threshold`, gating `detection`. |
| `min_expression_gini` | numeric (default = -Inf). Minimum coefficient, gating `expression_gini`. |
| `min_detection_gini` | numeric (default = -Inf). Minimum coefficient, gating `detection_gini`. |
| `detection_threshold` | numeric (default = 0). Value above which a cell counts as expressing a feature. Not a filter on returned rows. |
| `min_length` | integer (default = 0). Pad each per-group vector to this length with copies of its minimum before taking the coefficient, removing the dependence on group count so scores compare across runs. `0` never pads. |
| `rank_score` | numeric (default = Inf). Keep a feature when its group is within this rank for both expression and detection. |
| `min_feats` | integer (default = 5). Keep this many top features per group regardless of the gates, so a group is never empty. |

The gates are OR'd with `min_feats`, so tightening them shrinks the
result toward `min_feats` per group and never below it.

Defaults here are
[`findGiniMarkers()`](https://giottosuite.com/dev/reference/findGiniMarkers.md)'s.
[`findGiniMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findGiniMarkers_one_vs_all.md)
passes `min_expression = 0.5`, `min_detection = 0.5` and `min_feats = 4`
explicitly; `comparison = "one_vs_rest"` does **not** switch them for
you.

## See also

[analyze_param](https://giottosuite.com/dev/reference/analyze_param.md),
[`markersParam()`](https://giottosuite.com/dev/reference/analyze_param.md),
[`findGiniMarkers()`](https://giottosuite.com/dev/reference/findGiniMarkers.md),
[featStatsParam](https://giottosuite.com/dev/reference/analyze_param.md)

Other marker detection parameters:
[`markers_scran`](https://giottosuite.com/dev/reference/markers_scran.md)
