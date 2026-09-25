# plotMotifGlyphs

Draws each motif as the little graph it actually is – nodes coloured by
cell type, edges as drawn – in a grid ranked by effect size.

A \`motif_id\` like \`size4_paw_A-B-B-C\` is not readable at a glance;
the same motif as four coloured dots joined the way the tissue joins
them is.

## Usage

``` r
plotMotifGlyphs(
  gobject,
  motif_result,
  top = 12L,
  order_by = c("z", "p_adj", "observed"),
  direction = c("enriched", "depleted", "both"),
  min_observed = 5,
  ncol = 4L,
  cell_color_code = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotMotifGlyphs"
)
```

## Arguments

- gobject:

  giotto object

- motif_result:

  output of \[cellProximityMotifs()\]

- top:

  number of motifs to draw

- order_by:

  \`"z"\`, \`"p_adj"\` or \`"observed"\`

- direction:

  which motifs to draw: \`"enriched"\`, \`"depleted"\` or \`"both"\`

- min_observed:

  drop motif classes seen fewer than this many times

- ncol:

  columns in the grid

- cell_color_code:

  optional named vector of cell type colours. Defaults to the object's
  discrete palette, so glyphs match the spatial plots.

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
plotMotifGlyphs(g, m, top = 12)
} # }
```
