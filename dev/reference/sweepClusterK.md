# Sweep a range of cluster numbers

Scores a partition at each k over a range, so the number of clusters is
chosen from the data rather than fixed by hand. Returns the scores and a
plot marking the k the chosen criterion favors.

## Usage

``` r
sweepClusterK(
  gobject = NULL,
  spat_unit = NULL,
  feat_type = NULL,
  values_to_use = c("dim_reduction", "spatial_enrichment"),
  dim_reduction_to_use = "pca",
  dim_reduction_name = NULL,
  dimensions_to_use = 1:10,
  spat_enr_name = NULL,
  x = NULL,
  k_range = 2:15,
  cluster_method = c("kmeans", "hclust"),
  score = c("silhouette", "wss", "gap"),
  dist_method = c("euclidean", "correlation"),
  hclust_method = "ward.D2",
  subsample = NULL,
  max_dist_obs = 20000L,
  seed = NULL,
  nstart = 5,
  iter_max = 50,
  n_perm = 25,
  line_color = "grey60",
  point_color = "#C44E52",
  title = NULL,
  xlab = NULL,
  ylab = NULL,
  axis_text = 9,
  axis_title = 10,
  theme_param = list(),
  output = c("plot", "data.table"),
  verbose = NULL,
  view = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "sweepClusterK"
)
```

## Arguments

- gobject:

  giotto object. The matrix to cluster is read from one of its slots,
  chosen with \`values_to_use\`. May be NULL when \`x\` is given.

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- values_to_use:

  character. Which slot supplies the matrix: "dim_reduction" (cluster
  cells in PC space), "spatial_enrichment" (cluster cells by
  neighborhood composition, which is how a niche k is chosen).

- dim_reduction_to_use, dim_reduction_name, dimensions_to_use:

  Which reduction and which of its components, for \`values_to_use =
  "dim_reduction"\`. A linear reduction: "pca", "nmf", "harmony" or
  "lsi".

- spat_enr_name:

  character. Enrichment to read, for \`values_to_use =
  "spatial_enrichment"\`. Defaults to the first stored.

- x:

  numeric matrix or data.frame of observations by variables, a `dist`,
  or the list from `spatialCoexpression(return_gobject = FALSE)`.
  Supplied, it is used instead of any slot. A co-expression result is
  not stored on a giotto object, so this is the only way to sweep
  co-expression modules.

- k_range:

  integer vector of cluster numbers to score.

- cluster_method:

  character. "kmeans" or "hclust". Forced to "hclust" for a
  co-expression result or a \`dist\`.

- score:

  character, one or more of "silhouette", "wss" and "gap". Several are
  drawn as panels, which is the honest way to show that they disagree.
  "wss" and "gap" need coordinates, so a co-expression result or a
  \`dist\` leaves only "silhouette". Left unset, all three are scored
  for k-means and only "silhouette" for a hierarchical cut.

- dist_method:

  character. Distance for the silhouette when \`x\` is a matrix:
  "euclidean" or "correlation" (\`1 - r\` between observations).

- hclust_method:

  character. Passed to
  [`stats::hclust`](https://rdrr.io/r/stats/hclust.html). Ignored for a
  co-expression result, whose own tree is used.

- subsample:

  integer or NULL. Observations to randomly sample before scoring. A
  silhouette needs every pairwise distance, so it is quadratic in
  observations and this is the only way to run one on a large object.

- max_dist_obs:

  integer. Refuse to build a distance above this many observations. The
  default of 20,000 is about 1.6 GB; half a million cells would be 892
  GB, so the refusal is there to name the number rather than let the
  allocation fail.

- seed:

  numeric or NULL. Seed for sampling and k-means starts.

- nstart, iter_max:

  numeric. Passed to
  [`stats::kmeans`](https://rdrr.io/r/stats/kmeans.html).

- n_perm:

  numeric. Reference datasets for the gap statistic, passed to
  [`cluster::clusGap`](https://rdrr.io/pkg/cluster/man/clusGap.html) as
  \`B\`. Ignored by the other criteria.

- line_color, point_color:

  character. Curve and marked point.

- title:

  character. Plot title.

- xlab, ylab:

  character. Axis titles. NULL names the criterion on y, and on x the
  number swept: modules for a co-expression result, clusters otherwise.

- axis_text, axis_title:

  numeric. Base sizes.

- theme_param:

  list. Passed to
  [`ggplot2::theme`](https://ggplot2.tidyverse.org/reference/theme.html).

- output:

  character. "plot" (default) draws the scores; "data.table" returns
  them instead: one row per k per criterion, with \`k\`, \`value\`,
  \`se\` (the gap's standard error, NA for the others), \`score\` and
  \`selected\`.

- verbose:

  be verbose

- view:

  character. Name of a
  [`GiottoClass::giottoView`](https://giotto-suite.github.io/GiottoClass/reference/giottoView.html)
  slotted on \`gobject\`, resolved once before the matrix is read.

- show_plot:

  logical. show plot

- return_plot:

  logical. return ggplot object

- save_plot:

  logical. save the plot

- save_param:

  list of saving parameters, see
  [`showSaveParameters`](https://giotto-suite.github.io/GiottoVisuals/reference/showSaveParameters.html)

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

## Value

ggplot, or a data.table when \`output = "data.table"\`

## Details

The criterion, not the clustering engine, is what makes this general. A
silhouette needs only a partition and a distance, so the same call
covers k-means over a composition matrix and a hierarchical cut of a
correlation matrix. Within-cluster sum of squares applies to k-means
alone, where the chosen k is the point furthest from the line joining
the ends of the curve.

The list returned by `spatialCoexpression(return_gobject = FALSE)` is
accepted directly. Its own tree is cut at each k and scored on the same
\`1 - r\` distance it was built from, so no second tree is fitted and
the k reported here is the \`n_modules\` to pass back to
[`spatialCoexpression()`](https://giottosuite.com/dev/reference/spatialCoexpression.md).
The \`n_modules\` used for that first call does not matter: the tree is
the same for every k.

A silhouette is quadratic in the number of observations, so
\`subsample\` exists for the cell-level case. It does not apply to a
co-expression result, where the observations are features and the tree
is already built.

Only linear reductions are read from the object. UMAP and t-SNE are
refused: they distort distances, so the silhouette and wss computed on
them are inflated and depend on the embedding's random seed, and on data
with no clusters at all they report structure that is not there.
Coordinates passed as \`x\` are used as given.

The marked k is the criterion's preference, not a recommendation.
Criteria disagree, and a k one step either side is usually defensible.

Which arguments apply depends on the input. A setting that would change
what is computed, but that the chosen input does not use, is ignored
with a warning when it was set explicitly: a linkage, distance or sample
for a co-expression result or a distance, a slot when \`x\` is supplied,
or the other slot's name. Other unused arguments are ignored silently.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

# k-means on the PCA, scored by within-cluster sum of squares
sweepClusterK(g, k_range = 2:10, score = "wss", seed = 1)

# the same partitions scored by silhouette, as a table
sweepClusterK(g, k_range = 2:10, score = "silhouette", seed = 1,
    output = "data.table")

# co-expression modules: sweep the tree spatialCoexpression() built
coexp <- spatialCoexpression(g, feats = head(rownames(g), 100),
    return_gobject = FALSE)
sweepClusterK(coexp, k_range = 2:12)
```
