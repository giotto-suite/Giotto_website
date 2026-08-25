# findGiniMarkers_one_vs_all

Identify marker feats for all clusters in a one vs all manner based on
gini detection and expression scores.

## Usage

``` r
findGiniMarkers_one_vs_all(
  gobject,
  feat_type = NULL,
  spat_unit = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column,
  subset_clusters = NULL,
  min_expression = 0.5,
  min_detection = 0.5,
  min_expression_gini = -Inf,
  min_detection_gini = -Inf,
  detection_threshold = 0,
  min_length = 0,
  rank_score = Inf,
  min_feats = 4,
  min_genes = NULL,
  verbose = TRUE,
  min_expr_gini_score = deprecated(),
  min_det_gini_score = deprecated()
)
```

## Arguments

- gobject:

  giotto object

- feat_type:

  feature type

- spat_unit:

  spatial unit

- expression_values:

  feat expression values to use

- cluster_column:

  clusters to use

- subset_clusters:

  selection of clusters to compare

- min_expression:

  minimum per-cluster mean expression, gating the `expression` column of
  the result

- min_detection:

  minimum fraction of a cluster's cells with expression above
  `detection_threshold`, gating the `detection` column of the result

- min_expression_gini:

  minimum gini coefficient of expression, gating the `expression_gini`
  column of the result. `-Inf` (default) disables it.

- min_detection_gini:

  minimum gini coefficient of detection, gating the `detection_gini`
  column of the result. `-Inf` (default) disables it.

- detection_threshold:

  expression value above which a cell counts as expressing a feature,
  used when computing `detection`. Not a filter on the returned rows –
  see `min_detection` for that.

- min_length:

  pad the per-cluster vector to this length before taking the gini
  coefficient, using copies of its minimum. Removes the dependence of
  the coefficient on how many clusters were compared, so gini scores and
  the `min_expression_gini` / `min_detection_gini` thresholds become
  comparable across runs. `0` (the default) never pads.

- rank_score:

  keep a feature when its cluster is within this rank for both
  `expression` and `detection`, where rank 1 is the cluster in which the
  feature is highest. `Inf` (default) disables it. Combined with
  `min_feats` by `or`, like the other gates.

- min_feats:

  minimum number of top feats to return

- min_genes:

  deprecated, use min_feats

- verbose:

  be verbose

- min_expr_gini_score:

  **\[deprecated\]** use `min_expression`. Despite its name it never
  gated a gini coefficient.

- min_det_gini_score:

  **\[deprecated\]** use `min_detection`. Despite its name it never
  gated a gini coefficient.

## Value

data.table with marker feats

## Details

Each cluster is compared against every other cluster pooled into a
single group, by calling
[`findGiniMarkers()`](https://giottosuite.com/dev/reference/findGiniMarkers.md)
once per cluster and keeping the rows belonging to the cluster under
test. See there for how the scores are built.

Because each of those calls compares exactly two groups, the gini
coefficients are taken over two values and so cannot exceed 0.50 — the
ceiling for `G` groups is `(G - 1) / G`. Thresholds passed to
`min_expression_gini` or `min_detection_gini` have to sit below that or
they reject every feature, leaving only the `min_feats` per cluster that
the filter always keeps.

Two groups also gives `rank_score` a direct reading here: with only the
cluster and the pooled rest to rank, `rank_score = 1` keeps a feature
only where the cluster under test is not beaten by the rest on either
mean expression or detection fraction — a tie counts, since tied groups
share rank 1. Any value above 1 admits every feature, there being no
third rank to exclude.

## Filtering

Two kinds of gate are available, and they do different jobs.

`min_expression` and `min_detection` are an abundance floor. The gini
coefficient is scale-free: a feature averaging 0.001 in one cluster
against 0.0001 in the rest scores exactly as specific as one averaging
100 against 10. It therefore carries no magnitude term, and will rank
near-noise features as perfectly selective. These two gates supply that
term. The equivalent for the other methods is `logFC`, which
[`findScranMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findScranMarkers_one_vs_all.md)
and
[`findMastMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findMastMarkers_one_vs_all.md)
filter on directly.

`min_expression_gini` and `min_detection_gini` gate the gini
coefficients themselves, and are off by default. They are best used on a
second pass: the returned table always carries the `expression_gini` and
`detection_gini` columns, so run once, look at their distribution, then
set a floor. What they add over `min_feats` is an *absolute* cutoff,
where `min_feats` is a *relative* one – it takes each cluster's top few
by `comb_score` however weak those are, while a gini floor is a
statement about the coefficient itself.

`rank_score` is a third kind: a position rather than a value. It keeps a
feature when the cluster in question is within the given rank for both
`expression` and `detection`, rank 1 being the cluster where the feature
is highest. So `rank_score = 1` means "this cluster tops the feature on
both measures", and `2` means "top two". It is off by default (`Inf`).
Clusters tied at the top all hold the same rank, so a tie does not
exclude them.

All four value comparisons are strict (`>`), so a value exactly equal to
its threshold does not pass; `rank_score` is inclusive (`<=`). The
strict case is worth knowing for `min_detection`, where the values are
fractions over a cluster's cell count and land on round numbers often.

Every gate is combined with `min_feats` by `or`, so a feature in the top
`min_feats` of its cluster by `comb_score` is kept regardless of all of
them. Setting the gates more strictly therefore shrinks the result
towards `min_feats` features per cluster, never below it.

## Comparing runs

A *run* here means one call together with the set of clusters that call
compares — `G` of them. A gini coefficient over `G` values cannot exceed
`(G - 1) / G`, so a coefficient is a property of the feature **and** of
the run that produced it, not of the feature alone.

`G` is not fixed by the dataset; it is set by the arguments. On the mini
visium object with seven leiden clusters:

|  |  |  |  |
|----|----|----|----|
| call | `G` | ceiling | highest `expression_gini` |
| [`findGiniMarkers()`](https://giottosuite.com/dev/reference/findGiniMarkers.md) | 7 | 0.857 | 0.484 |
| `findGiniMarkers(subset_clusters = 3 of them)` | 3 | 0.667 | 0.443 |
| `findGiniMarkers(group_1 =, group_2 =)` | 2 | 0.500 | 0.390 |
| `findGiniMarkers_one_vs_all()` | 2 | 0.500 | 0.309 |

The feature `Mustn1` scores 0.484 in the full run and 0.238 in the
three-cluster subset — the same cells, the same expression, half the
coefficient, because `subset_clusters` changed what it was compared
against. That is the boundary: any point where a coefficient produced
under one `G` is read against one produced under another.

`min_length` pads the per-cluster vector with copies of its own minimum
before the coefficient is taken, fixing the ceiling at
`(min_length - 1) / min_length` for any run with fewer clusters than
that, and so putting runs with different `G` back on one scale.

Padding is not a neutral rescaling, and it is not strictly better than
leaving it off. Two things follow from the padding value being *each
feature's own minimum*. It reorders features within a single run,
because a feature with a floor of zero gains far more from padding than
one with a high floor — measured on mini visium, padded and unpadded
`expression_gini` correlate at 0.95, not 1.0. And it asserts something
the data does not contain: `c(10, 0)` scores 0.50 over two groups and
0.9375 padded to sixteen, which amounts to assuming the feature would
sit at its observed minimum in fourteen groups nobody measured. Being
top of two clusters really is weaker evidence of specificity than being
top of twenty; the unpadded ceiling is that fact, not an artefact.

So this is a deliberate trade — a comparable number in exchange for an
assumption — and it cannot be chosen automatically, because the right
value depends on which *other* runs the score has to line up with, which
a single call cannot see.

**Leave it at `0` when** you are reading one run's results on their own
terms — the default, and the case that needs no assumption. Nothing in
the returned table requires an absolute coefficient: `comb_rank`,
`min_feats` and `rank_score` are all relative to the run, and the gini
columns are only being read against each other.

**Set it when a gini number has to mean the same thing twice.** In rough
order of how easily each is hit:

- comparing a full run against one narrowed by `subset_clusters`, or
  against a `group_1`/`group_2` pairwise call — the same object and the
  same clustering, but a different `G`, so the coefficients are not on
  one scale;

- comparing
  [`findGiniMarkers()`](https://giottosuite.com/dev/reference/findGiniMarkers.md)
  against `findGiniMarkers_one_vs_all()`, whose two-group comparisons
  are capped at 0.50 while a 20-cluster run reaches 0.95;

- reusing one `min_expression_gini` or `min_detection_gini` threshold
  across clustering resolutions, or across datasets, where the cluster
  count differs;

- reporting a coefficient as a property of a feature rather than of one
  analysis.

All four are the same situation: a coefficient produced under one `G`
being read against one produced under another.

Pick a value at least as large as the biggest cluster count you want to
compare across. Below that, a run with more clusters than `min_length`
is left unpadded and the scales still differ. Above it there is no real
cost: padding harder widens the range rather than compressing it, and
barely touches the ordering (measured on the mini visium dataset,
`min_length` of 16 versus 100 gives a Spearman correlation of 0.998
between the resulting coefficients). `16` is the value this padding
shipped with historically and fixes the ceiling at 0.9375.

Turning it on is not free. Every gini score changes, so results stop
being comparable with unpadded runs — pad both sides or neither. And
since `comb_score` is built from the coefficients, the reordering
described above propagates: on mini visium `min_length = 16` moves
`comb_rank` for 98% of rows, which changes which features `min_feats`
rescues and therefore which features are returned at all.

To perform differential expression between custom selected groups of
cells you need to specify the cell_ID column to parameter
*cluster_column* and provide the individual cell IDs to the parameters
*group_1* and *group_2*

By default group names will be created by pasting the different id names
within each selected group. When you have many different ids in a single
group it is recommend to provide names for both groups to *group_1_name*
and *group_2_name*

## See also

[`findGiniMarkers`](https://giottosuite.com/dev/reference/findGiniMarkers.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

findGiniMarkers_one_vs_all(g, cluster_column = "leiden_clus")
```
