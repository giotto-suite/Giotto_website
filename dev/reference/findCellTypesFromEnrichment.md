# findCellTypesFromEnrichment

findCellTypesFromEnrichment

## Usage

``` r
findCellTypesFromEnrichment(
  gobject = NULL,
  spat_unit = NULL,
  feat_type = NULL,
  enrichment_name = "PAGE_z_score",
  return_frequency_table = FALSE
)
```

## Arguments

- gobject:

  Giotto Object

- spat_unit:

  spatial unit in which the enrichment information is stored

- feat_type:

  feature type for which the enrichment information was calculated

- enrichment_name:

  name of the spatial enrichment i.e. output from
  GiottoClass::list_spatial_enrichment_names() Default value is
  "PAGE_Z_score"

- return_frequency_table:

  see details. Default FALSE

## Value

table

## Details

This function returns a two-column matrix, one column will contain cell
IDs and the other will contain the most likely cell type based on the
provided enrichment.

By setting return_frequency_table to TRUE, a table will instead be
returned. This table will detail the number of occurences for each cell
type, based on the provided enrichment.

The cell types are assigned by determining the maximum value of the
z-score or -log10(p-value) for a cell and the associated cell types from
the enrichment.
