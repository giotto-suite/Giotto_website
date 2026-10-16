# Motif enrichment parameters

Parameter classes for \[analyzeData()\] motif enrichment. \`motifParam\`
is the VIRTUAL contract; concrete subclasses select an engine.
\`motifParam()\` is the factory.

A backend supplies a concrete subclass and an \`analyzeData\` method on
it. The method receives the network carrier, plus the cell type labels
named by node ID, and must return the result contract described in
\[cellProximityMotifs()\]. The carrier is what the spatial network
holds: an \`igraph\` whose vertex names are cell IDs, or a backed store,
whose methods come from the package that owns its class.

## Usage

``` r
motifParam(
  method = "auto",
  size = 3L,
  null = c("label", "stratified", "conditional"),
  n_perm = 1000L,
  set_seed = TRUE,
  seed_number = 1234,
  ...
)

# S4 method for class 'igraph,autoMotifParam'
analyzeData(x, param, ...)

# S4 method for class 'igraph,smotifParam'
analyzeData(x, param, cell_type = NULL, strata = NULL, anchored_on = NULL, ...)

# S4 method for class 'giotto,motifParam'
analyzeData(
  x,
  param,
  spat_unit = NULL,
  feat_type = NULL,
  spatial_network_name = "Delaunay_network",
  cluster_column = NULL,
  strata_column = NULL,
  anchored_on = NULL,
  ...
)
```

## Arguments

- method:

  engine to use. \`"auto"\` picks the best available: smotif when
  installed.

- size:

  motif size: 2, 3 or 4.

- null:

  null model. \`"label"\` permutes cell type labels over all cells;
  \`"stratified"\` permutes within strata; \`"conditional"\` holds the
  observed pairwise composition fixed, so a 3- or 4-cell motif that is
  still enriched is enriched beyond what its constituent pairs already
  explain.

- n_perm:

  number of null draws.

- set_seed, seed_number:

  seed control.

- ...:

  further engine-specific arguments.

- x:

  a \`giotto\` object, or a network carrier (an \`igraph\`, or a backed
  store)

- cell_type:

  cell type labels, one per node, named by node ID (carrier methods
  only)

- strata:

  optional strata, one per node, named by node ID (carrier methods only)

- anchored_on:

  optional character vector of cell IDs

- spat_unit, feat_type:

  spatial unit and feature type

- spatial_network_name:

  name of the spatial network to use

- cluster_column:

  cell metadata column holding cell type labels

- strata_column:

  optional cell metadata column to stratify the null by

## Value

a \`motifParam\` subclass object
