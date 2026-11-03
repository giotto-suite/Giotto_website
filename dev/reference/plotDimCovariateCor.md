# Correlate reduced dimensions with cell covariates

Correlates each component of a dimension reduction against one or more
numeric cell covariates, to show whether a component is tracking a
technical variable such as sequencing depth rather than biology.

One covariate gives a bar per component. Several give a tile heatmap of
components by covariate.

## Usage

``` r
plotDimCovariateCor(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  dim_reduction_to_use = "pca",
  dim_reduction_name = NULL,
  covariates = c("total_expr", "nr_feats"),
  dimensions_to_use = 1:30,
  cor_method = c("pearson", "spearman", "kendall"),
  transform = NULL,
  threshold = 0.6,
  show_values = NULL,
  max_value_cols = 20,
  value_text_angle = 0,
  dims_on_y = NULL,
  digits = 2,
  gradient_color = c("white", "#C44E52"),
  gradient_limits = c(0, 1),
  bar_color = c("grey75", "#C44E52"),
  title = NULL,
  xlab = NULL,
  ylab = NULL,
  x_text_size = 8,
  y_text_size = 9,
  x_text_angle = 0,
  axis_text = 9,
  axis_title = 10,
  show_legend = TRUE,
  theme_param = list(),
  verbose = NULL,
  view = NULL,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "plotDimCovariateCor"
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- dim_reduction_to_use:

  character. A linear reduction: "pca", "nmf", "harmony" or "lsi".

- dim_reduction_name:

  character. Name of the stored reduction. Defaults to the first found
  for \`dim_reduction_to_use\`.

- covariates:

  numeric cell metadata column names, or a matrix or data.frame of
  numeric covariates whose rownames are cell IDs. The default names are
  written by
  [`addStatistics()`](https://giottosuite.com/dev/reference/addStatistics.md).

- dimensions_to_use:

  numeric. Indices of the components to show, as elsewhere in Giotto.
  Indices beyond the stored components are dropped.

- cor_method:

  character. Correlation method for
  [`stats::cor`](https://rdrr.io/r/stats/cor.html).

- transform:

  character, "log10" or "none", one value for all covariates or one per
  covariate. "log10" uses \`log10(pmax(x, 1))\`. A count wants a log and
  a coordinate must not have one, so mixed covariates take one value
  each, in the order given. NULL (default) uses "log10" for cell
  metadata columns and "none" for a supplied matrix.

- threshold:

  numeric or NULL. Advisory line; NULL draws none.

- show_values:

  logical, or NULL to print the values only where they fit. Horizontal
  space is what runs out, so NULL counts the columns the plot ends up
  with, after \`dims_on_y\` has been settled, and suppresses the values
  past \`max_value_cols\`. Twenty components against four covariates
  prints in either orientation; thirty components across the x axis does
  not.

- max_value_cols:

  numeric. Columns above which \`show_values = NULL\` stops printing.

- value_text_angle:

  numeric. Rotation of the printed values, matching \`x_text_angle\` for
  the axis. 90 buys room on a wide, short grid.

- dims_on_y:

  logical, or NULL to decide from the shape. TRUE puts the components on
  the vertical axis, which is the readable orientation when there are
  many components and few covariates.

- digits:

  numeric. Decimal places for printed values.

- gradient_color:

  character vector of two. Low and high heatmap colors.

- gradient_limits:

  numeric of two. Color scale limits.

- bar_color:

  character vector of two. Below- and above-threshold bars.

- title:

  character. Plot title.

- xlab, ylab:

  character. Axis titles. NULL names the reduction and the covariate,
  which is usually what you want.

- x_text_size, y_text_size, x_text_angle:

  numeric. Axis text.

- axis_text, axis_title:

  numeric. Base sizes.

- show_legend:

  logical.

- theme_param:

  list. Passed to
  [`ggplot2::theme`](https://ggplot2.tidyverse.org/reference/theme.html).

- verbose:

  be verbose

- view:

  character. Name of a
  [`GiottoClass::giottoView`](https://giotto-suite.github.io/GiottoClass/reference/giottoView.html)
  slotted on \`gobject\`. Supplied, the object is narrowed once before
  either slot is read, so the reduction and the metadata share one
  resolver pass.

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

Only linear reductions are accepted: PCA, NMF, Harmony-corrected PCs and
LSI, whose components are the ones later steps choose from. UMAP and
t-SNE are refused: their axes are coordinates of a nonlinear fit, not
components that can be kept or dropped.

\`threshold\` is advisory. With thousands of cells every correlation is
statistically significant, so the only question is effect size. The
default 0.6 means the covariate accounts for about a third of that
component's variance. It colors bars and nothing else; deciding what to
drop is still yours, and dropping several components risks discarding
biology.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

# does any principal component track depth or detected features?
plotDimCovariateCor(g)

# one covariate gives a bar per component
plotDimCovariateCor(g, covariates = "total_expr", dimensions_to_use = 1:10)
```
