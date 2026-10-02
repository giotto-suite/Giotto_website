# Splits of a cluster tree as a table

One row per split (internal node) of a tree from
\[calculateClusterTree()\], root first: \* \`nodeID\` — the
\`tree\$merge\` row. The same node numbering
\[findClusterTreeMarkers()\], \[writeClusterTreeQuery()\] and
\[annotateClusterTree()\] (\`labels\$nodes\`) use. \* \`node_h\` — the
height of the join \* \`left\`, \`right\` — the clusters on each side,
as character vectors

## Usage

``` r
# S3 method for class 'giottoTree'
as.data.frame(x, ...)

# S3 method for class 'giottoTree'
as.data.table(x, ...)
```

## Arguments

- x:

  a \`giottoTree\`

- ...:

  ignored

## Value

a \`data.frame\`, or a \`data.table\` from \`as.data.table()\`

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
tree <- calculateClusterTree(g, cluster_column = "leiden_clus")
data.table::as.data.table(tree)
```
