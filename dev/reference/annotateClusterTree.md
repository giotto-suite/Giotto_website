# annotateClusterTree

Write cluster-tree annotations onto a giotto object at one or more
levels of granularity, from a single set of labels.

## Usage

``` r
annotateClusterTree(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  tree,
  labels,
  cluster_column,
  k = NULL,
  h = NULL,
  name = NULL,
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

- tree:

  an \`hclust\` over the clusters, from \[calculateClusterTree()\]

- labels:

  the annotation, as a list with \`clusters\` (one label per leaf) and
  optionally \`nodes\` (one label per internal node). Both may be named
  character vectors or \`data.frame\`s; see details.

- cluster_column:

  name of the cell metadata column holding the clusters

- k, h:

  granularity, passed to \[stats::cutree()\]. Either may be a vector,
  giving one annotation column per value. \`k = NULL, h = NULL\` writes
  the leaf labels unchanged.

- name:

  names for the columns written. Defaults to \`cell_types_k\<k\>\` /
  \`cell_types_h\<h\>\`, or \`cell_types\` for the leaf level.

- ...:

  passed to \[GiottoClass::annotateGiotto()\]

## Value

the giotto object, with one cell metadata column per requested level

## Details

A tree annotated at every node can be read at any depth without asking
the annotator again: cutting it at \`k\` groups and naming each group is
pure tree arithmetic. That is what this does, so a user can compare a
coarse and a fine labelling of the same cells side by side.

## Resolving a label for a group

An annotator will not always name every node, and a partially labelled
tree still has to produce a column with no holes in it. Each group takes
the first of these that resolves:

1\. the label of the group's own root node 2. the leaf's own label, when
the group is a single cluster 3. the nearest \*\*labelled ancestor\*\* –
a coarser name is always true of a subset, so this is a widening, not a
guess 4. the majority label among the group's leaves

The order of 2 and 3 is load-bearing. No internal node spans a single
leaf, so at the finest cut every group is a singleton with no node of
its own; if the ancestor search came first, the finest level would come
back coarser than the leaf labels it was built from.

## See also

\[calculateClusterTree()\], \[writeClusterTreeQuery()\],
\[GiottoVisuals::plotClusterTree()\]

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

tree <- calculateClusterTree(g, cluster_column = "leiden_clus")
labs <- list(clusters = stats::setNames(
    paste("type", tree$labels), tree$labels
))
g <- annotateClusterTree(g,
    tree = tree, labels = labs,
    cluster_column = "leiden_clus", k = c(2, 4)
)
pDataDT(g)
```
