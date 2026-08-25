# readPolygonFilesVizgen

Read selected polygon files for the FOVs present in the Giotto object
and add the smoothed polygons to the object

## Usage

``` r
readPolygonFilesVizgen(
  gobject,
  boundaries_path,
  fovs = NULL,
  polygon_feat_types = 0:6,
  flip_x_axis = FALSE,
  flip_y_axis = FALSE,
  smooth_polygons = TRUE,
  smooth_vertices = 60,
  set_neg_to_zero = FALSE,
  return_gobject = TRUE,
  verbose = TRUE
)

.h5_read_vizgen(
  h5File,
  z_indices = 1L:7L,
  segm_to_use = "p_0",
  H5Fopen_flags = "H5F_ACC_RDWR"
)
```

## Arguments

- gobject:

  giotto object

- boundaries_path:

  path to the cell_boundaries folder

- fovs:

  selected fovs, if NULL select all fovs within Giotto object

- polygon_feat_types:

  a vector containing the polygon feature types

- flip_x_axis:

  flip x axis of polygon coordinates (multiply by -1)

- flip_y_axis:

  flip y axis of polygon coordinates (multiply by -1)

- smooth_polygons:

  smooth polygons (default = TRUE)

- smooth_vertices:

  number of vertices for smoothing

- set_neg_to_zero:

  set negative values to zero when smoothing

- return_gobject:

  return giotto object

- verbose:

  be verbose

## Value

giotto object or cell polygons list

## Functions

- `.h5_read_vizgen()`: (internal) Optimized .hdf5 reading for vizgen
  merscope output. Returns a data.table of xyz coords and cell_id

## See also

[`smoothGiottoPolygons`](https://giotto-suite.github.io/GiottoClass/reference/smoothGiottoPolygons.html)
