# plotCellTypeNTScore

plot NTScore by cell type

## Usage

``` r
plotCellTypeNTScore(
  gobject,
  cell_type,
  values = "NTScore",
  spat_unit = "cell",
  feat_type = "niche cluster",
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "CellTypeNTScore"
)
```

## Arguments

- gobject:

  giotto object

- cell_type:

  the cell type column name in the metadata

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- show_plot:

  logical. show plot

- return_plot:

  logical. return ggplot object

- save_plot:

  logical. save the plot

- save_param:

  list of saving parameters, see
  [`showSaveParameters`](https://giotto-suite.github.io/GiottoVisuals/reference/showSaveParameters.html)

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

## Value

ggplot
