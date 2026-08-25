# cellProximitySpatPlot2D

Visualize 2D cell-cell interactions according to spatial coordinates in
ggplot mode

## Usage

``` r
cellProximitySpatPlot2D(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  spat_loc_name = NULL,
  interaction_name = NULL,
  cluster_column = NULL,
  sdimx = "sdimx",
  sdimy = "sdimy",
  cell_color = NULL,
  cell_color_code = NULL,
  color_as_factor = TRUE,
  show_other_cells = FALSE,
  show_network = FALSE,
  show_other_network = FALSE,
  network_color = NULL,
  spatial_network_name = "Delaunay_network",
  show_grid = FALSE,
  grid_color = NULL,
  spatial_grid_name = "spatial_grid",
  coord_fix_ratio = 1,
  show_legend = TRUE,
  point_size_select = 2,
  point_select_border_col = "black",
  point_select_border_stroke = 0.05,
  point_size_other = 1,
  point_alpha_other = 0.3,
  point_other_border_col = "lightgrey",
  point_other_border_stroke = 0.01,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "cellProximitySpatPlot2D"
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- spat_loc_name:

  spatial locations to use

- interaction_name:

  cell-cell interaction name

- cluster_column:

  cluster column with cell clusters

- sdimx:

  x-axis dimension name (default = 'sdimx')

- sdimy:

  y-axis dimension name (default = 'sdimy')

- cell_color:

  character. what to color cells by (e.g. metadata col or spatial
  enrichment col)

- cell_color_code:

  character. discrete colors to use. palette to use or named vector of
  colors

- color_as_factor:

  logical. convert color column to factor. discrete colors are used when
  this is TRUE. continuous colors when FALSE.

- show_other_cells:

  decide if show cells not in network

- show_network:

  show spatial network of selected cells

- show_other_network:

  show spatial network of not selected cells

- network_color:

  color of spatial network

- spatial_network_name:

  name of spatial network to use

- show_grid:

  show spatial grid

- grid_color:

  color of spatial grid

- spatial_grid_name:

  name of spatial grid to use

- coord_fix_ratio:

  fix ratio between x and y-axis

- show_legend:

  logical. show legend

- point_size_select:

  size of selected points

- point_select_border_col:

  border color of selected points

- point_select_border_stroke:

  stroke size of selected points

- point_size_other:

  size of other points

- point_alpha_other:

  opacity of other points

- point_other_border_col:

  border color of other points

- point_other_border_stroke:

  stroke size of other points

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

## Details

Description of parameters.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
g <- createSpatialGrid(g, sdimx_stepsize = 5, sdimy_stepsize = 5)
x <- cellProximityEnrichment(g, cluster_column = "leiden_clus")

cellProximitySpatPlot2D(
    gobject = g, cluster_column = "leiden_clus",
    interaction_name = x
)
```
