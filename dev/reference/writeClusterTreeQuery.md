# writeClusterTreeQuery

Build the annotation query for a cluster tree: the tree itself, the
markers separating the two sides of every branch, and the per-cluster
markers with a specificity flag.

## Usage

``` r
writeClusterTreeQuery(
  gobject,
  tree,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column = NULL,
  view = NULL,
  markers = NULL,
  gini_markers = NULL,
  node_markers = NULL,
  context = list(),
  margin_cut = 25,
  top_markers = 20L,
  top_gini = 5L,
  top_node = 10L,
  file_name = NULL
)
```

## Arguments

- gobject:

  giotto object

- tree:

  a \`giottoTree\` from \[calculateClusterTree()\], or any \`hclust\`
  over the clusters

- spat_unit, feat_type, expression_values, cluster_column, view:

  default to those recorded on a \`giottoTree\`; see the giottoTree
  section of \[calculateClusterTree()\]. An explicit value overrides the
  tree's, with a warning when they differ. \`cluster_column\` is
  required for a plain \`hclust\`. \`expression_values\` and \`view\`
  apply only to the evidence layers this function computes itself: cell
  counts and any marker table not supplied.

- markers:

  one-vs-all marker table, from \[findMarkers_one_vs_all()\]. Computed
  when not supplied.

- gini_markers:

  gini marker table, from \[findGiniMarkers_one_vs_all()\]. Computed
  when not supplied; supplies the specificity flag.

- node_markers:

  output of \[findClusterTreeMarkers()\]. Computed when not supplied.

- context:

  named list of whatever is known about the sample – \`tissue\`,
  \`disease\`, \`assay\`, anything else. Rendered as \`Name: value\`
  lines at the top of the query.

- margin_cut:

  detection margin, in percentage points, below which a cluster is
  flagged as having no feature of its own

- top_markers, top_gini, top_node:

  how many genes to list per cluster and per branch side

- file_name:

  optional path to write the query to. The text is returned either way.

## Value

the query, as a character vector, invisibly

## Details

Runs no LLM. It assembles the text to hand to one, exactly as
\[writeChatGPTqueryDEG()\] does for a flat marker list.

What it adds over a flat list is structure. The query asks for a label
at \*\*every internal node\*\* as well as every leaf, and a node's label
must name the clade beneath it rather than describe the split. That is
what lets \[annotateClusterTree()\] cut the answer at any granularity
afterwards without asking the model again.

## See also

\[calculateClusterTree()\], \[findClusterTreeMarkers()\],
\[annotateClusterTree()\]

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

tree <- calculateClusterTree(g, cluster_column = "leiden_clus")
q <- writeClusterTreeQuery(g, tree,
    context = list(tissue = "mouse brain")
)
head(q, 20)
```
