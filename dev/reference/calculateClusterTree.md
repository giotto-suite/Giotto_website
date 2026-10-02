# calculateClusterTree

Hierarchically cluster the clusters, by correlating their mean
expression profiles.

## Usage

``` r
calculateClusterTree(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column,
  feats = NULL,
  cor = c("pearson", "spearman"),
  distance = "ward.D",
  view = NULL
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

  expression values to use

- cluster_column:

  name of the cell metadata column holding the clusters

- feats:

  optional character vector of features to restrict the correlation to.
  Highly variable features are a common choice; \`NULL\` uses every
  feature.

- cor:

  correlation score to calculate distance

- distance:

  distance method to use for hierarchical clustering

- view:

  optional \`character(1)\` naming a slotted view. The tree is built
  from the cells that survive it: the per-cluster means are taken over
  those cells only, and a cluster with none left is not a leaf.

## Value

a \`giottoTree\`: an \`hclust\` whose leaf labels are the cluster
labels, recording the settings it was built from (\`spat_unit\`,
\`feat_type\`, \`expression_values\`, \`cluster_column\`, \`view\`,
\`feats\`, ...) as the attribute \`"params"\`, and the correlation
matrix as \`"cor_matrix"\`. \`feats\` is \`NULL\` when every feature was
used, and otherwise the features actually present.

## Details

The per-cluster means come from \`analyzeData(x,
analyzeParam("feat_stats"), groups =)\`, which is one pass over the
expression values on any backend, including a disk-backed store.
\[GiottoClass::calculateMetaTable()\] takes its per-group means through
the same call.

## giottoTree

The class is \`c("giottoTree", "hclust")\`, so \[stats::cutree()\],
\[stats::as.dendrogram()\], \`plot()\`, \`ggdendro\`, \`dendextend\` and
\`ape\` all treat it as the \`hclust\` it is.

A tree is the grouping: which clusters sit on each side of each split.
Functions that analyse along it (\[findClusterTreeMarkers()\],
\[writeClusterTreeQuery()\], \[annotateClusterTree()\]) take their
defaults for \`cluster_column\`, \`spat_unit\`, \`feat_type\`,
\`expression_values\` and \`view\` from the recorded settings. Which
data they use is still the caller's choice: an explicit argument always
wins, with a warning when it differs from what the tree recorded, since
the results then describe different data than the splits. A plain
\`hclust\` from elsewhere works too, with those arguments passed
explicitly.

\`as.data.frame()\` / \`data.table::as.data.table()\` on a
\`giottoTree\` give one row per split; see
\[as.data.frame.giottoTree()\].

Cluster labels are ordered naturally before the correlation is taken.
This matters more than it looks: ward linkage breaks near-ties by index,
so correlating the same profiles in lexical order (\`"1"\`, \`"10"\`,
..., \`"2"\`) rather than natural order can yield a measurably different
tree.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

tree <- calculateClusterTree(g, cluster_column = "leiden_clus")
plot(tree)
data.table::as.data.table(tree)
```
