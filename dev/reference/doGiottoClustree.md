# doGiottoClustree

cluster cells using leiden methodology to visualize different
resolutions

## Usage

``` r
doGiottoClustree(
  gobject,
  res_vector = NULL,
  res_seq = NULL,
  return_gobject = FALSE,
  show_plot = NULL,
  save_plot = NULL,
  return_plot = NULL,
  save_param = list(),
  default_save_name = "clustree",
  verbose = TRUE,
  ...
)
```

## Arguments

- gobject:

  giotto object

- res_vector:

  vector of different resolutions to test

- res_seq:

  list of float numbers indicating start, end, and step size for
  resolution testing, i.e. (0.1, 0.6, 0.1)

- return_gobject:

  default FALSE. See details for more info.

- show_plot:

  by default, pulls from provided gobject instructions

- save_plot:

  by default, pulls from provided gobject instructions

- return_plot:

  by default, pulls from provided gobject instructions

- save_param:

  list of saving parameters from
  [`GiottoVisuals::all_plots_save_function()`](https://giotto-suite.github.io/GiottoVisuals/reference/plot_save.html)

- default_save_name:

  name of saved plot, default "clustree"

- verbose:

  be verbose

- ...:

  Arguments passed on to `clustree::clustree`

  `prefix`

  :   string indicating columns containing clustering information

  `suffix`

  :   string at the end of column names containing clustering
      information

  `metadata`

  :   data.frame containing metadata on each sample that can be used as
      node aesthetics

  `count_filter`

  :   count threshold for filtering edges in the clustering graph

  `prop_filter`

  :   in proportion threshold for filtering edges in the clustering
      graph

  `layout`

  :   string specifying the "tree" or "sugiyama" layout, see
      [`igraph::layout_as_tree()`](https://r.igraph.org/reference/layout_as_tree.html)
      and
      [`igraph::layout_with_sugiyama()`](https://r.igraph.org/reference/layout_with_sugiyama.html)
      for details

  `use_core_edges`

  :   logical, whether to only use core tree (edges with maximum in
      proportion for a node) when creating the graph layout, all
      (unfiltered) edges will still be displayed

  `highlight_core`

  :   logical, whether to increase the edge width of the core network to
      make it easier to see

  `node_colour`

  :   either a value indicating a colour to use for all nodes or the
      name of a metadata column to colour nodes by

  `node_colour_aggr`

  :   if `node_colour` is a column name than a string giving the name of
      a function to aggregate that column for samples in each cluster

  `node_size`

  :   either a numeric value giving the size of all nodes or the name of
      a metadata column to use for node sizes

  `node_size_aggr`

  :   if `node_size` is a column name than a string giving the name of a
      function to aggregate that column for samples in each cluster

  `node_size_range`

  :   numeric vector of length two giving the maximum and minimum point
      size for plotting nodes

  `node_alpha`

  :   either a numeric value giving the alpha of all nodes or the name
      of a metadata column to use for node transparency

  `node_alpha_aggr`

  :   if `node_aggr` is a column name than a string giving the name of a
      function to aggregate that column for samples in each cluster

  `node_text_size`

  :   numeric value giving the size of node text if `scale_node_text` is
      `FALSE`

  `scale_node_text`

  :   logical indicating whether to scale node text along with the node
      size

  `node_text_colour`

  :   colour value for node text (and label)

  `node_text_angle`

  :   the rotation of the node text

  `node_label`

  :   additional label to add to nodes

  `node_label_aggr`

  :   if `node_label` is a column name than a string giving the name of
      a function to aggregate that column for samples in each cluster

  `node_label_size`

  :   numeric value giving the size of node label text

  `node_label_nudge`

  :   numeric value giving nudge in y direction for node labels

  `edge_width`

  :   numeric value giving the width of plotted edges

  `edge_arrow`

  :   logical indicating whether to add an arrow to edges

  `edge_arrow_ends`

  :   string indicating which ends of the line to draw arrow heads if
      `edge_arrow` is `TRUE`, one of "last", "first", or "both"

  `show_axis`

  :   whether to show resolution axis

  `return`

  :   string specifying what to return, either "plot" (a `ggplot`
      object), "graph" (a `tbl_graph` object) or "layout" (a `ggraph`
      layout object)

  `exprs`

  :   source of gene expression information to use as node aesthetics,
      for `SingleCellExperiment` objects it must be a name in
      `assayNames(x)`, for a `seurat` object it must be one of `data`,
      `raw.data` or `scale.data` and for a `Seurat` object it must be
      one of `data`, `counts` or `scale.data`

  `assay`

  :   name of assay to pull expression and clustering data from for
      `Seurat` objects

## Value

a plot object (default), OR a giotto object (if specified)

## Details

This function tests different resolutions for Leiden clustering and
provides a visualization of cluster sizing as resolution varies.

By default, the tested leiden clusters are NOT saved to the Giotto
object, and a plot is returned.

If return_gobject is set to TRUE, and a giotto object with *all* tested
leiden cluster information will be returned.

## See also

[`doLeidenCluster`](https://giottosuite.com/dev/reference/doLeidenCluster.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

doGiottoClustree(
    gobject = g, res_vector = c(0.5, 0.8), return_plot = FALSE,
    show_plot = FALSE, save_plot = FALSE
)
```
