# Calculate Pixel to Micron Scalefactor

Calculate Pixel to Micron Scalefactor

## Usage

``` r
.visium_micron_scale(json_scalefactors)
```

## Arguments

- json_scalefactors:

  list of scalefactors from .visium_read_scalefactors()

## Value

scale factor for converting pixel to micron

## Details

Calculates pixel to micron scalefactor. Visium xy coordinates are based
on the fullres image The values provided are directly usable for
generating polygon information or calculating the micron size relative
to spatial coordinates for this set of spatial information.
