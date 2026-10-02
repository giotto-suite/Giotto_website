# getDendrogramSplits

Deprecated. Build the tree with \[calculateClusterTree()\]; then
\`data.table::as.data.table(tree)\` gives the same table (with \`left\`
/ \`right\` for \`tree_1\` / \`tree_2\`), and \`plot(tree)\` draws it.
See \[as.data.frame.giottoTree()\].

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

  optional \`hclust\` from \[calculateClusterTree()\]

- verbose:

  be verbose

## Value

\`data.table\` with one row per internal node, ordered from highest node
to lowest: \`node_h\`, \`tree_1\` and \`tree_2\` (list columns of
cluster labels either side of the split), and \`nodeID\` (the
\`hclust\$merge\` row).
