# plotCellTypesFromEnrichment

plotCellTypesFromEnrichment

## Usage

``` r
plotCellTypesFromEnrichment(
  gobject = NULL,
  spat_unit = NULL,
  feat_type = NULL,
  enrichment_name = "PAGE_z_score",
  title = NULL,
  save_param = list(),
  default_save_name = "cell_types_from_enrichment",
  save_plot = NULL,
  show_plot = NULL,
  return_plot = NULL
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

- title:

  Title of the generated plot. Default \`paste0(spat_unit,"cell types
  (maximum", enrichment_name, ")")\`

- save_param:

  list of saving parameters, see
  [`showSaveParameters`](https://giotto-suite.github.io/GiottoVisuals/reference/showSaveParameters.html)

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

- save_plot:

  logical. save the plot

- show_plot:

  logical. show plot

- return_plot:

  logical. return ggplot object

## Value

plot

## Details

This function generates a bar plot of cell types vs the frequency of
that cell type in the data. These cell type results are based on the
provided \`enrichment_name\`, and will be determined by the maximum
value of the z-score or p-value for a given cell or annotation.
