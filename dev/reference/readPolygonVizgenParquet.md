# Read MERSCOPE polygons from parquet

Read Vizgen exported cell boundary parquet files as giottoPolyons. The z
level can be selected.

## Usage

``` r
readPolygonVizgenParquet(
  file,
  z_index = "all",
  calc_centroids = TRUE,
  verbose = TRUE
)
```

## Arguments

- file:

  parquet file to load

- z_index:

  either 'all' or a numeric vector of z_indices to get polygons for

- calc_centroids:

  calculate centroids for the polygons (default = TRUE)

- verbose:

  be verbose

## Value

giottoPolygons
