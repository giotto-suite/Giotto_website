# spatMotifPlot

Shows where a motif actually sits in the tissue: the cells taking part
in each occurrence, over a faint background of all other cells.

Above \`density_threshold\` cells the occurrences are drawn as a
two-dimensional density instead of individual points, so the figure
stays readable on a million-cell section rather than becoming a solid
block.

## Usage

``` r
spatMotifPlot(
  gobject,
  motif_id,
  cluster_column,
  spat_unit = NULL,
  feat_type = NULL,
  spatial_network_name = "Delaunay_network",
  size = 3L,
  point_size = 1.2,
  background_size = 0.4,
  density_threshold = 20000L,
  max_per_class = 20000L,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "spatMotifPlot"
)
```

## Arguments

- gobject:

  giotto object

- motif_id:

  one or more \`motif_id\` values to show

- cluster_column:

  cell metadata column with the cell type labels the motifs were
  computed from

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- spatial_network_name:

  spatial network the motifs were computed on

- size:

  motif size the ids came from

- point_size, background_size:

  point sizes for participating and non-participating cells

- density_threshold:

  above this many participating cells, draw a density surface rather
  than points

- max_per_class:

  cap on occurrences fetched per motif class

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

## Examples

``` r
if (FALSE) { # \dontrun{
g <- GiottoData::loadGiottoMini("visium")
m <- cellProximityMotifs(g, cluster_column = "leiden_clus", size = 3L)
spatMotifPlot(g, m$motif_id[1], cluster_column = "leiden_clus")
} # }
```
