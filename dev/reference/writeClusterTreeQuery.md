# writeClusterTreeQuery

Build the annotation query for a cluster tree: the tree itself, the
markers separating the two sides of every branch, and the per-cluster
markers with a specificity flag.

## Usage

``` r
writeClusterTreeQuery(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  cluster_column,
  tree,
  splits = NULL,
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

- spat_unit:

  spatial unit

- feat_type:

  feature type

- expression_values:

  feature expression values to use. Consulted only for evidence layers
  this function has to compute itself; one supplied by the caller was
  already built on some choice of values.

- cluster_column:

  name of the cell metadata column holding the clusters

- tree:

  an \`hclust\` over the clusters, from \[calculateClusterTree()\]

- splits:

  the node table for \`tree\`, from \[getDendrogramSplits()\]. Derived
  from \`tree\` when not supplied.

- markers:

  one-vs-all marker table, from \[findMarkers_one_vs_all()\]. Computed
  when not supplied.

- gini_markers:

  gini marker table, from \[findGiniMarkers_one_vs_all()\]. Computed
  when not supplied; supplies the specificity flag.

- node_markers:

  output of \[findNodeMarkers()\]. Computed when not supplied.

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

\[calculateClusterTree()\], \[findNodeMarkers()\],
\[annotateClusterTree()\]

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

tree <- calculateClusterTree(g, cluster_column = "leiden_clus")
q <- writeClusterTreeQuery(g,
    cluster_column = "leiden_clus", tree = tree,
    context = list(tissue = "mouse brain")
)
head(q, 20)
```
