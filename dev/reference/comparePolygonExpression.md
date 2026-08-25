# Compare gene expression between polygon areas

Compare gene expression between polygon areas

## Usage

``` r
comparePolygonExpression(
  gobject,
  polygon_name = "selections",
  spat_unit = "cell",
  feat_type = "rna",
  selected_feats = "top_genes",
  expression_values = "normalized",
  method = "scran",
  ...
)
```

## Arguments

- gobject:

  A Giotto object

- polygon_name:

  name of polygon selections

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- selected_feats:

  vector of selected features to plot

- expression_values:

  gene expression values to use ("normalized", "scaled", "custom")

- method:

  method to use to detect differentially expressed feats ("scran",
  "gini", "mast")

- ...:

  Arguments passed to
  [Heatmap](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)

## Value

A ComplexHeatmap::Heatmap object

## Examples

``` r
## Plot interactive polygons
g <- GiottoData::loadGiottoMini("visium")
my_polygon_coords <- data.frame(
    poly_ID = rep("polygon1", 3),
    sdimx = c(5477, 5959, 4720), sdimy = c(-4125, -2808, -5202)
)

## Add polygon coordinates to Giotto object
my_giotto_polygons <- createGiottoPolygonsFromDfr(my_polygon_coords,
    name = "selections"
)
g <- addGiottoPolygons(
    gobject = g,
    gpolygons = list(my_giotto_polygons)
)

## Add polygon cells
g <- addPolygonCells(g)

comparePolygonExpression(g)
```
