# getDendrogramSplits

Split dendrogram at each node and keep the leave (label) information.

## Usage

``` r
getDendrogramSplits(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column,
  cor = c("pearson", "spearman"),
  distance = "ward.D",
  h = NULL,
  h_color = "red",
  show_dend = TRUE,
  tree = NULL,
  verbose = TRUE
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

  name of column to use for clusters

- cor:

  correlation score to calculate distance

- distance:

  distance method to use for hierarchical clustering

- h:

  height of horizontal lines to plot

- h_color:

  color of horizontal lines

- show_dend:

  show dendrogram

- tree:

  optional \`hclust\` from \[calculateClusterTree()\]. When supplied the
  tree is not rebuilt, so the splits, the dendrogram plot and any other
  consumer can share one.

- verbose:

  be verbose

## Value

\`data.table\` with one row per internal node, ordered from highest node
to lowest: \`node_h\` (numeric height), \`tree_1\` and \`tree_2\` (list
columns of cluster labels either side of the split), and \`nodeID\` (the
\`hclust\$merge\` row the node corresponds to).

## Details

Creates a data.table where each row represents a node in the dendrogram.
For each node the height of the node is given together with the two
subdendrograms. This information can be used to determine in a
hierarchical manner differentially expressed marker genes at each node.

\`nodeID\` is the \`merge\` row index, so per-node results join back to
the clustering. It was previously a row counter (\`"node_1"\`,
\`"node_2"\`, ...) with no defined relationship to the tree.

\`tree_1\` and \`tree_2\` are \*\*list columns\*\* of cluster labels, so
feeding a node to a marker function needs \`unlist()\`:

“\` splits \<- getDendrogramSplits(g, cluster_column = "leiden_clus")
findScranMarkers(g, cluster_column = "leiden_clus", group_1 =
unlist(splits\[1\]\$tree_1), group_2 = unlist(splits\[1\]\$tree_2) ) “\`

Looping that over the rows gives differential expression at every node.
Each call reads only the cells under its own node, so the total work is
roughly the tree depth times one pass rather than one pass per node.

The tree itself is built by \[calculateClusterTree()\]. Pass one in as
\`tree\` to reuse the same tree across the splits, the dendrogram plot
and any per-node analysis, instead of rebuilding it here.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

getDendrogramSplits(g, cluster_column = "leiden_clus")
```
