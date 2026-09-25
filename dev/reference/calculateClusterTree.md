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
  distance = "ward.D"
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

## Value

an \`hclust\` whose leaf labels are the cluster labels, carrying the
correlation matrix and the settings used as the attributes
\`"cor_matrix"\` and \`"params"\`.

## Details

The per-cluster means come from \`analyzeData(x,
analyzeParam("feat_stats"), groups =)\`, which is one pass over the
expression values on any backend, including a disk-backed store.
\[GiottoClass::calculateMetaTable()\] computes the same statistic with
one pass per cluster.

A plain \`hclust\` is returned rather than a new class so that
\[stats::cutree()\], \[stats::as.dendrogram()\], \`ggdendro\`,
\`dendextend\` and \`ape\` all work on it unchanged.

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
getDendrogramSplits(g, cluster_column = "leiden_clus", tree = tree)
```
