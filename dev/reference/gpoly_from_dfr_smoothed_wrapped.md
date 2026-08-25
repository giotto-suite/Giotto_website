# Polygon creation and smoothing for parallel

Polygon creation and smoothing for parallel

## Usage

``` r
gpoly_from_dfr_smoothed_wrapped(
  segmdfr,
  name = "cell",
  calc_centroids = FALSE,
  smooth_polygons = FALSE,
  vertices = 20L,
  k = 3L,
  set_neg_to_zero = TRUE,
  skip_eval_dfr = FALSE,
  copy_dt = TRUE,
  verbose = TRUE
)
```

## Value

giottoPolygon
