# chooseAvailableSpatialGenes

function to find the test name for existing spatial gene sets in Giotto

## Usage

``` r
chooseAvailableSpatialGenes(gobject, spat_unit = NULL, feat_type = NULL)
```

## Arguments

- gobject:

  Giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

## Value

character

## Details

This function outputs the available test name for existing spatial gene
sets in Giotto, which could be used in parameter ‘name’ in
\`filterSpatialGenes\`. Priorities for showing the spatial gene test
names are ‘binSpect’ \> ‘silhouetteRankTest’ \> ‘silhouetteRank’.
