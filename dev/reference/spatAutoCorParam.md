# Spatial autocorrelation parameters

Settings for detecting spatially autocorrelated features over a spatial
network. Significance comes from the randomisation null in closed form:
the exact mean and variance of the statistic over all permutations of a
feature's values across cells (Cliff and Ord 1981), so nothing is
shuffled.

\* \`"moran"\` — Moran's I of each feature's values. \* \`"geary"\` —
Geary's C of each feature's values. \* \`"binspect"\` — binSpect: each
feature is binarized per cell (see \[threshold_binarize\]) and tested
with the black-black join count, the number of edges with both ends on.
This is Moran's I of the binarized feature up to the network's degree
variation, and the 2x2 table of edge types it summarises is the one
binSpect has always used (Dries et al. 2021); the odds ratio of that
table is reported alongside.

## Usage

``` r
spatAutoCorParam(
  method = c("moran", "geary", "binspect", "joincount"),
  null = c("permutation", "covariate"),
  covariate = "libsize",
  n_groups = 10L,
  weighted = FALSE,
  adjust_method = "fdr",
  bin_method = c("kmeans", "rank"),
  percentage_rank = 30,
  ...
)

# S4 method for class 'ANY,spatAutoCorParam'
analyzeData(x, param, ..., network, groups = NULL)

# S4 method for class 'giotto,spatAutoCorParam'
analyzeData(
  x,
  param,
  ...,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = "normalized",
  spatial_network_name = "Delaunay_network",
  feats = NULL,
  return_gobject = FALSE
)
```

## Arguments

- method:

  one of \`"moran"\`, \`"geary"\`, \`"binspect"\`; \`"joincount"\` is
  another name for \`"binspect"\` (the same test, the same result
  columns).

- null:

  \`"permutation"\` (default) or \`"covariate"\`. The covariate null
  asks whether a feature clusters beyond what a cell grouping explains:
  cells are grouped by \`covariate\`, and Moran's I is taken of each
  value minus its group's mean, or binSpect's join count is compared
  with cells switching on at their group's rate. Use it when something
  other than location – sequencing depth, cell type – varies across the
  tissue and would otherwise make many features look spatial. Not
  available for \`"geary"\`; binSpect needs an unweighted network.

- covariate:

  for \`null = "covariate"\` on a \`giotto\` object: \`"libsize"\` (the
  cells' total raw counts) or a cell metadata column. A numeric
  covariate is cut into \`n_groups\` quantile groups; a categorical one
  is used as is. Matrix and store inputs take the grouping directly as
  \`groups =\`.

- n_groups:

  number of quantile groups for a numeric covariate.

- weighted:

  logical. Use the network's edge weights.

- adjust_method:

  p-value adjustment, passed to \[stats::p.adjust()\].

- bin_method, percentage_rank:

  binarization for \`"binspect"\`: the \`threshold\` rule and
  \`percentage_rank\` of \[threshold_binarize\].

- ...:

  additional named entries to attach to \`@param\`.

- x:

  data to test: a feature x cell matrix, an expression store, or a
  \`giotto\` object

- param:

  a \[spatAutoCorParam-class\]

- network:

  the spatial network matching \`x\`: for a matrix, a \`data.frame\` of
  \`from\`, \`to\` (cell IDs) and optionally \`weight\`, or an
  \`igraph\`; for a GiottoDisk store, its \`parquetEdgeStore\`

- groups:

  for \`null = "covariate"\` on a matrix or store: the cell grouping,
  one label per cell, named by cell ID

- spat_unit, feat_type:

  spatial unit and feature type

- expression_values:

  expression values to use

- spatial_network_name:

  name of the spatial network to use

- feats:

  optional feature IDs to test; \`NULL\` tests every feature. Each
  feature's statistic does not depend on the others, but the p-value
  adjustment counts only the features tested.

- return_gobject:

  logical. Return the \`giotto\` object with the results in its feature
  metadata instead of the result table.

## Value

A concrete \`spatAutoCorParam\` subclass object.

\`analyzeData()\`: a \`data.table\` with one row per feature, ordered by
decreasing \`z\`: \`feats\`, \`statistic\`, \`expected\`, \`variance\`,
\`z\`, \`p.value\`, \`adj.p.value\`; binSpect adds \`n_on\` (cells
called on) and \`odds_ratio\` (of the 2x2 table of edge types). With
\`return_gobject = TRUE\`, the \`giotto\` object with \`\<method\>.z\`,
\`\<method\>.p\` and \`\<method\>.padj\` added to the feature metadata,
plus \`binSpect.pval\` (the adjusted p-value) for binSpect.

## Features that do not vary

A feature with the same value in every cell (all zero, or constant), or
for binSpect one binarized all on or all off, has no randomisation null.
Its \`z\`, \`p.value\` and \`adj.p.value\` are \`NA\`, as is a statistic
that is undefined for it (Moran's I, Geary's C); it is left out of the
p-value adjustment and sorts last.

## References

Cliff, A. D. and Ord, J. K. (1981). Spatial Processes: Models and
Applications. Pion.

Dries, R. et al. (2021). Giotto: a toolbox for integrative analysis and
visualization of spatial expression data. Genome Biology 22, 78.

## Examples

``` r
p <- spatAutoCorParam("moran")
p_cov <- spatAutoCorParam("moran", null = "covariate", covariate = "libsize")
p_bin <- spatAutoCorParam("binspect", bin_method = "rank")
```
