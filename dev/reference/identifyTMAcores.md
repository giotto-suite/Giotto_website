# Split cluster annotations based on a spatial network

Split cluster annotations based on a spatial network

## Usage

``` r
identifyTMAcores(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  spatial_network_name = "Delaunay_network",
  core_id_name = "core_id",
  id_fmt = "%d",
  include_all_ids = TRUE,
  missing_id_name = "not_connected",
  min_nodes = 5,
  join_split_cores = TRUE,
  join_tolerance = 1.2,
  return_gobject = TRUE
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- spatial_network_name:

  character. Name of spatial network to use

- core_id_name:

  metadata column name for the core information

- id_fmt:

  character. \[sprintf\] formatting to use for core ids

- include_all_ids:

  logical. Include all ids, including vertex ids not found in the
  spatial network

- missing_id_name:

  character. Name for nodes that are not connected to a core.

- min_nodes:

  numeric. Minimal number of nodes to not be considered an unconnected
  group.

- join_split_cores:

  logical. Attempt to repair core IDs when a core is split down the
  middle and detected as two different cores.

- join_tolerance:

  numeric. Max ratio allowed relative to previous max core convex hull
  area when determining if a pair of cores should be joined.

- return_gobject:

  logical. Return giotto object

## Value

cluster annotations
