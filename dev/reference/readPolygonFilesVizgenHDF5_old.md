# readPolygonFilesVizgenHDF5

Read and create polygons for all cells, or for only selected FOVs.

## Usage

``` r
readPolygonFilesVizgenHDF5_old(
  boundaries_path,
  fovs = NULL,
  polygon_feat_types = 0:6,
  custom_polygon_names = NULL,
  flip_x_axis = FALSE,
  flip_y_axis = FALSE,
  smooth_polygons = TRUE,
  smooth_vertices = 60,
  set_neg_to_zero = FALSE,
  H5Fopen_flags = "H5F_ACC_RDWR",
  cores = NA,
  verbose = TRUE
)
```

## Arguments

- boundaries_path:

  path to the cell_boundaries folder

- fovs:

  subset of fovs to use

- polygon_feat_types:

  a vector containing the polygon feature types

- custom_polygon_names:

  a character vector to provide custom polygon names (optional)

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

- H5Fopen_flags:

  see `H5Fopen` for more details

- cores:

  cores to use

- verbose:

  be verbose

## Value

data.table

## Details

Set H5Fopen_flags to "H5F_ACC_RDONLY" if you encounter permission
issues.

## See also

[`smoothGiottoPolygons`](https://giotto-suite.github.io/GiottoClass/reference/smoothGiottoPolygons.html)
