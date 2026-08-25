# Calculate spatial enrichment

Calculate spatial enrichment. Multiple methods are provided.

## Usage

``` r
.calc_spatial_enrichment_minimum(
  spatial_network,
  bin_matrix,
  adjust_method = "fdr",
  do_fisher_test = TRUE
)

.calc_spatial_enrichment_matrix(
  spatial_network,
  bin_matrix,
  adjust_method = "fdr",
  do_fisher_test = TRUE,
  do_parallel = TRUE,
  cores = NA,
  calc_hub = FALSE,
  hub_min_int = 3,
  verbose = TRUE
)

.calc_spatial_enrichment_dt(
  bin_matrix,
  spatial_network,
  calc_hub = FALSE,
  hub_min_int = 3,
  group_size = "automatic",
  do_fisher_test = TRUE,
  adjust_method = "fdr",
  cores = NA
)
```

## Value

spatial enrichment

## Functions

- `.calc_spatial_enrichment_minimum()`: calculate using a 'simple' and
  efficient for loop

- `.calc_spatial_enrichment_matrix()`: calculate using 'matrix'
  implementation

- `.calc_spatial_enrichment_dt()`: calculate using 'data.table'
  implementation
