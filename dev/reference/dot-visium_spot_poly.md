# Create Polygons for Visium Data

Create Polygons for Visium Data

## Usage

``` r
.visium_spot_poly(spatlocs = NULL, micron_scale)
```

## Arguments

- spatlocs:

  spatial locations data.table or `spatLocsObj` containing centroid
  locations of visium spots

- micron_scale:

  microns per spatial unit, from .visium_micron_scale()

## Value

giottoPolygon object

## Details

Creates circular polygons for spatial representation of Visium spots, 55
um across.
