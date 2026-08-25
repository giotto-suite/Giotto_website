# Spatial autocorrelation

Find spatial autocorrelation. Note that `spatialAutoCorGlobal` will
return values as a data.table instead of appending information to the
gobject. `spatialAutoCorLocal` will append the results as a spatial
enrichment object by default.  
If providing external data using either the `node_values` and/or
`weight_matrix` params, the order of values provided should be the same
as the ordering of the columns and rows of the weight matrix.

## Usage

``` r
spatialAutoCorGlobal(
  gobject = NULL,
  spat_unit = NULL,
  feat_type = NULL,
  feats = NULL,
  method = c("moran", "geary"),
  data_to_use = c("expression", "cell_meta"),
  expression_values = c("normalized", "scaled", "custom"),
  meta_cols = NULL,
  spatial_network_to_use = "kNN_network",
  wm_method = c("distance", "adjacency"),
  wm_name = "spat_weights",
  node_values = NULL,
  weight_matrix = NULL,
  test_method = c("none", "monte_carlo"),
  mc_nsim = 99,
  cor_name = NULL,
  return_gobject = FALSE,
  verbose = TRUE
)

spatialAutoCorLocal(
  gobject = NULL,
  spat_unit = NULL,
  feat_type = NULL,
  feats = NULL,
  method = c("moran", "gi", "gi*", "mean"),
  data_to_use = c("expression", "cell_meta"),
  expression_values = c("normalized", "scaled", "custom"),
  meta_cols = NULL,
  spatial_network_to_use = "kNN_network",
  wm_method = c("distance", "adjacency"),
  wm_name = "spat_weights",
  node_values = NULL,
  weight_matrix = NULL,
  test_method = c("none"),
  enrich_name = NULL,
  return_gobject = TRUE,
  output = c("spatEnrObj", "data.table"),
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

- feats:

  features (expression) on which to run autocorrelation. (leaving as
  NULL means that all features will be tested)

- method:

  method of autocorrelation. See details (default = 'moran')

- data_to_use:

  if using data from gobject, whether to test using expression
  ('expression') or cell metadata ('cell_meta')

- expression_values:

  name of expression information to use

- meta_cols:

  columns in cell metadata to test

- spatial_network_to_use:

  spatial network to use

- wm_method:

  type of weight matrix to generate from spatial network if no weight
  matrix is found attached to the spatial network

- wm_name:

  name of attached weight matrix to use

- node_values:

  alternative method of directly supplying a set of node values

- weight_matrix:

  alternative method of directly supplying a spatial weight matrix

- test_method:

  method to test values for significance (default is no testing)

- mc_nsim:

  when `test_method = 'monte_carlo'` this is number of simulations to
  perform

- cor_name:

  name to assign the results in global autocorrelation output

- return_gobject:

  (default = FALSE) whether to return results appended to

- verbose:

  be verbose

- enrich_name:

  name to assign local autocorrelation spatial enrichment results

- output:

  'spatEnrObj' or 'data.table' metadata in the giotto object or as a
  data.table

## Value

spatial autocorrelation

## Details

**Global Methods:**

- *Moran's I* 'moran'

- *Geary's C* 'geary'

**Local Methods:**

- *Local Moran's I* 'moran'

- *Getis-Ord Gi* 'Gi'

- *Getis-Ord Gi\** 'Gi\*'

- *Local mean* 'mean'

## Functions

- `spatialAutoCorGlobal()`: Global autocorrelation (single value
  returned)

- `spatialAutoCorLocal()`: Local autocorrelation (values generated for
  each spatial ID)
