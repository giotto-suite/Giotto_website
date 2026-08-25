# filterSpatialGenes

function to filter gene list with existing spatial gene sets

## Usage

``` r
filterSpatialGenes(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  spatial_genes,
  max = 2500,
  name = c("binSpect", "silhouetteRank", "silhouetteRankTest"),
  method = c("none", "elbow")
)
```

## Arguments

- gobject:

  Giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- spatial_genes:

  input gene list

- max:

  max number of genes selected from spatial test

- name:

  name of spatial gene test for the filtering

- method:

  method of spatial gene selection

## Value

list

## Details

This function filters given gene list with the gene sets of selected
spatial gene test in Giotto, also controls the total size of the gene
set with given max number.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

filterSpatialGenes(g, spatial_genes = "Gm19935")
```
