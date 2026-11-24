# Plots for edgeicg interaction-changed features

Views of an `icfObject` from
[`findInteractionChangedFeats()`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)
with `method = "edgeicg"`:

- `plotICFOverview()`: hits per receiver and sender type at each scale
  (dot size: number of hits; colour: share going up).

- `plotICFLeak()`: the estimated transcript leak between touching cells
  (`lambda`: the share of a touching sender's expression found in the
  receiver), which edgeicg removes before testing.

- `plotICFPair()`: all features tested for one receiver and sender at
  one scale, effect size against significance, coloured by hit class.

- `plotICFExposure()`: receiver expression (share of the cell's raw
  counts) against exposure to the sender, in exposure bins; the first
  bin holds the unexposed receivers.

- `plotICFAttribution()`: for niche hits, how much of the evidence each
  sender type explains (Wakefield attribution with a 95% credible set).

- `plotICFRegion()`: for a fit with `region_column`, the effect of each
  feature within each region (log2 FC with a 95% interval; filled =
  significant in that region), titled with the between-region pattern.

## Usage

``` r
plotICFOverview(
  gobject,
  icfObject,
  scale = c("contact", "paracrine", "niche"),
  q_thr = 0.05,
  min_lfc = NULL,
  classes = "clean",
  include_regional = FALSE,
  cell_order = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotICFOverview"
)

plotICFLeak(
  gobject,
  icfObject,
  cell_order = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotICFLeak"
)

plotICFPair(
  gobject,
  icfObject,
  receiver,
  sender,
  scale = c("contact", "paracrine", "niche"),
  q_thr = 0.05,
  n_labels = 4L,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotICFPair"
)

plotICFExposure(
  gobject,
  icfObject,
  receiver,
  sender,
  feats,
  scale = c("niche", "paracrine", "contact"),
  n_bins = 8L,
  spat_unit = NULL,
  feat_type = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotICFExposure"
)

plotICFAttribution(
  gobject,
  icfObject,
  receiver,
  feats,
  cell_order = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotICFAttribution"
)

plotICFRegion(
  gobject,
  icfObject,
  receiver,
  sender,
  feats,
  scale = c("contact", "paracrine", "niche"),
  regions = NULL,
  q_thr = 0.05,
  min_lfc = 0.25,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotICFRegion"
)
```

## Arguments

- gobject:

  giotto object

- icfObject:

  output of `findInteractionChangedFeats(method = "edgeicg")`

- scale:

  one or more of `"contact"`, `"paracrine"`, `"niche"`

- q_thr, min_lfc:

  significance and effect-size thresholds for a hit (default: the
  `min_lfc` of the icfObject)

- classes:

  hit classes to count (`"clean"`, `"sender_marker"`, `"other_marker"`,
  `"own_down"`); default `"clean"`

- include_regional:

  count niche hits flagged as regional

- cell_order:

  optional order of cell types on the axes

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

- receiver, sender:

  receiver and sender cell types

- n_labels:

  features labelled per class

- feats:

  features to show

- n_bins:

  number of exposure bins for the exposed receivers

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- regions:

  optional regions to show, in this order

## Value

ggplot

## See also

[`findInteractionChangedFeats()`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md),
[`icfParam()`](https://giottosuite.com/dev/reference/icf_param.md)
