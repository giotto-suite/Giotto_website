# showCellProportionSwitchedSanKey

showCellProportionSwitchedSanKey

## Usage

``` r
showCellProportionSwitchedSanKey(
  gobject = NULL,
  spat_unit = NULL,
  alt_spat_unit = NULL,
  feat_type = NULL
)
```

## Arguments

- gobject:

  giotto object which contains metadata for both spat_unit and
  alt_spat_unit

- spat_unit:

  spatial unit

- alt_spat_unit:

  alternative spatial unit which stores data after resizing annotations

- feat_type:

  feature type

## Value

D3 JavaScript Sankey diagram

## Details

Creates a Sankey Diagram to illustrate cluster switching behavior.
Currently only supports displaying cluster switching for kmeans
clusters.
