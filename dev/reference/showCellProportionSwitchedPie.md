# showCellProportionSwitchedPie

showCellProportionSwitchedPie

## Usage

``` r
showCellProportionSwitchedPie(
  gobject = NULL,
  spat_unit = NULL,
  feat_type = NULL
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

## Value

ggplot

## Details

Creates a pie chart showing how many cells switched clusters after
annotation resizing. The function showPolygonSizeInfluence() must have
been run on the Giotto Object for this function to run.
