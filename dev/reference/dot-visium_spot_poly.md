# Create Polygons for Visium Data

Create Polygons for Visium Data

## Usage

``` r
.visium_spot_poly(spatlocs = NULL, json_scalefactors)
```

## Arguments

- spatlocs:

  spatial locations data.table or `spatLocsObj` containing centroid
  locations of visium spots

- json_scalefactors:

  list of scalefactors from .visium_read_scalefactors()

## Value

giottoPolygon object

## Details

Creates circular polygons for spatial representation of Visium spots.
