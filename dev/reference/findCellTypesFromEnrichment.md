# findCellTypesFromEnrichment

findCellTypesFromEnrichment

## Usage

``` r
findCellTypesFromEnrichment(
  gobject = NULL,
  spat_unit = NULL,
  feat_type = NULL,
  enrichment_name = "PAGE",
  return_frequency_table = FALSE,
  min_score = NULL,
  max_padj = NULL,
  return_gobject = FALSE
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

  name of the spatial enrichment, as listed by
  `list_spatial_enrichments_names()` (default "PAGE")

- return_frequency_table:

  see details. Default FALSE

- min_score:

  leave a cell unassigned (`NA`) when its top score is below this
  (default NULL: no threshold). Not used for an enrichment of p-values.

- max_padj:

  leave a cell unassigned (`NA`) when the adjusted p-value of its top
  type, from the `<enrichment_name>_padj` enrichment that
  `p_value = TRUE` stores, is above this (default NULL: no threshold)

- return_gobject:

  add the assignment to the cell metadata as `<enrichment_name>_type`
  and return the giotto object (default FALSE)

## Value

a data.table of `cell_ID` and `probable_cell_type`, a frequency table,
or the giotto object (`return_gobject = TRUE`)

## Details

Each cell is assigned the cell type with the highest score in the
enrichment or, for an enrichment of p-values, the lowest p-value. Ties
go to the first type. `min_score` and `max_padj` leave cells without a
confident type unassigned.

By setting return_frequency_table to TRUE, a table of the number of
cells per cell type is returned instead, unassigned cells counted as
`NA`.
