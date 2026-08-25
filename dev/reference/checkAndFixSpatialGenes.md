# checkAndFixSpatialGenes

function to check the selected test name for spatial gene set in Giotto
object

## Usage

``` r
checkAndFixSpatialGenes(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  use_spatial_genes,
  use_score = FALSE
)
```

## Arguments

- gobject:

  Giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- use_spatial_genes:

  test name of spatial gene set to check

- use_score:

  logical variable to select silhouetteRank score

## Value

character

## Details

This function checks the user specified test name of spatial gene set in
Giotto object. SilhouetteRank works only with score, and
SilhouetteRankTest works only with pval. Use parameter use_score to
specify.
