# showPolygonSizeInfluence

showPolygonSizeInfluence

## Usage

``` r
showPolygonSizeInfluence(
  gobject = NULL,
  spat_unit = NULL,
  alt_spat_unit = NULL,
  feat_type = NULL,
  clus_name = "kmeans",
  return_plot = FALSE,
  verbose = FALSE
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- alt_spat_unit:

  alternaitve spatial unit which represents resized polygon data

- feat_type:

  feature type

- clus_name:

  name of cluster column in cell_metadata for given spat_unit and
  alt_spat_unit, i.e. "kmeans"

- return_plot:

  logical. whether to return the plot object

- verbose:

  be verbose

## Value

giotto object with altered cell_metadata

## Details

Compares cell metadata from spat_unit-feat_type pairs as provided.

New columns, resize_switch and cluster_interaction, will be created
within cell_metadata for spat_unit-feat_type.

These new columns will describe if a given cell switched cluster number
when resized. If the same amount of clusters exist for
spat_unit-feat_type and alt_spat_unit-feat_type, then clusters are
determined to be corresponding based on

Otherwise, multiple clusters from the spatial unit feature type pair are
condensed to align with the smaller number of clusters and ensure
overlap.
