# Add Visium Polygons to Giotto Object

Add Visium Polygons to Giotto Object

## Usage

``` r
addVisiumPolygons(gobject, scalefactor_path = NULL)
```

## Arguments

- gobject:

  Giotto Object created with visium data, containing spatial locations
  corresponding to spots

- scalefactor_path:

  path to scalefactors_json.json Visium output

## Value

Giotto Object with to-scale circular polygons added at each spatial
location

## Details

Adds circular giottoPolygons to the spatial_info slot of a Giotto Object
for the "cell" spatial unit.
