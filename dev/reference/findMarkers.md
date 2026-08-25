# findMarkers

Identify marker feats for selected clusters.

## Usage

``` r
findMarkers(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column = NULL,
  method = c("scran", "gini", "mast"),
  subset_clusters = NULL,
  group_1 = NULL,
  group_2 = NULL,
  min_expression = 0.5,
  min_detection = 0.5,
  min_expression_gini = -Inf,
  min_detection_gini = -Inf,
  detection_threshold = 0,
  min_length = 0,
  rank_score = Inf,
  min_feats = 4,
  min_genes = NULL,
  group_1_name = NULL,
  group_2_name = NULL,
  adjust_columns = NULL,
  min_expr_gini_score = deprecated(),
  min_det_gini_score = deprecated(),
  ...
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- expression_values:

  feat expression values to use

- cluster_column:

  clusters to use

- method:

  method to use to detect differentially expressed feats

- subset_clusters:

  selection of clusters to compare

- group_1:

  group 1 cluster IDs from cluster_column for pairwise comparison

- group_2:

  group 2 cluster IDs from cluster_column for pairwise comparison

- min_expression:

  gini: minimum per-cluster mean expression

- min_detection:

  gini: minimum fraction of a cluster's cells with expression above
  \`detection_threshold\`

- min_expression_gini:

  gini: minimum gini coefficient of expression. \`-Inf\` (default)
  disables it.

- min_detection_gini:

  gini: minimum gini coefficient of detection. \`-Inf\` (default)
  disables it.

- detection_threshold:

  gini: expression value above which a cell counts as expressing a
  feature

- min_length:

  gini: pad the per-cluster vector to this length before taking the gini
  coefficient, making scores comparable across runs with different
  cluster counts. \`0\` (the default) never pads.

- rank_score:

  gini: keep a feature when its cluster is within this rank for both
  \`expression\` and \`detection\` (rank 1 = highest). \`Inf\` (default)
  disables it.

- min_feats:

  minimum number of top feats to return (for gini)

- min_genes:

  deprecated, use min_feats

- group_1_name:

  mast: custom name for group_1 clusters

- group_2_name:

  mast: custom name for group_2 clusters

- adjust_columns:

  mast: column in pDataDT to adjust for (e.g. detection rate)

- min_expr_gini_score:

  \`r lifecycle::badge("deprecated")\` use \`min_expression\`. Despite
  its name it never gated a gini coefficient.

- min_det_gini_score:

  \`r lifecycle::badge("deprecated")\` use \`min_detection\`. Despite
  its name it never gated a gini coefficient.

- ...:

  additional parameters for the findMarkers function in scran or zlm
  function in MAST

## Value

data.table with marker feats

## Details

Wrapper for all individual functions to detect marker feats for
clusters.

## See also

[`findScranMarkers`](https://giottosuite.com/dev/reference/findScranMarkers.md),
[`findGiniMarkers`](https://giottosuite.com/dev/reference/findGiniMarkers.md)
and
[`findMastMarkers`](https://giottosuite.com/dev/reference/findMastMarkers.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

findMarkers(g, cluster_column = "leiden_clus")
```
