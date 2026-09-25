# plotMotifEnrichment

Triage plot for deciding which motifs are worth pursuing out of the
thousands a size-4 run produces. Enriched and depleted motifs appear in
one frame, split by topology.

The default \`style = "effect"\` plots effect size against how often the
motif actually occurs, with significance as colour. That is deliberate:
permutation p-values are floored at \`1 / (n_perm + 1)\`, so on a real
run most significant classes sit exactly on that floor and a volcano's
y-axis collapses to a single line carrying no information. Effect size
and occurrence count both vary, and together they are what separates a
real finding from a large z-score built on three occurrences.

\`style = "volcano"\` gives the conventional view for when p-values are
not saturated – raise \`n_perm\` to lower the floor.

## Usage

``` r
plotMotifEnrichment(
  gobject,
  motif_result,
  style = c("effect", "volcano"),
  p_thresh = 0.05,
  min_observed = 5,
  top = 15L,
  facet_topology = TRUE,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotMotifEnrichment"
)
```

## Arguments

- gobject:

  giotto object

- motif_result:

  output of \[cellProximityMotifs()\]

- style:

  \`"effect"\` plots effect size against occurrence count with
  significance as colour; \`"volcano"\` plots effect size against
  \`-log10(p_adj)\`. See Description for why \`"effect"\` is the
  default.

- p_thresh:

  adjusted p-value threshold for calling a motif significant

- min_observed:

  drop motif classes seen fewer than this many times. Rare classes carry
  unstable effect sizes and dominate the axes.

- top:

  number of most significant motifs to label

- facet_topology:

  draw one panel per topology

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
plotMotifEnrichment(g, m)
} # }
```
