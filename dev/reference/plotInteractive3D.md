# Plot interactive 3D spatial plot

Plot interactive 3D spatial plot

## Usage

``` r
plotInteractive3D(
  gobject,
  spat_unit = "cell",
  feat_type = "rna",
  cell_color = "leiden_clus",
  cell_color_code = NULL,
  point_size = 0.5,
  width = "100%",
  height = "400px"
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- cell_color:

  character. What to color cells by (e.g. metadata col or spatial
  enrichment col)

- cell_color_code:

  character. discrete colors to use. Palette to use or named vector of
  colors

- point_size:

  size of point (cell)

- width:

  plot width

- height:

  plot height

## Value

data.table with selected cell_IDs, spatial coordinates, and cluster_ID.
