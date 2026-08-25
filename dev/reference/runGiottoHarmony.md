# runGiottoHarmony

run UMAP

## Usage

``` r
runGiottoHarmony(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  vars_use = "list_ID",
  reduction = "cells",
  dim_reduction_to_use = "pca",
  dim_reduction_name = NULL,
  dimensions_to_use = 1:10,
  name = NULL,
  set_seed = TRUE,
  seed_number = 1234,
  toplevel_params = deprecated(),
  toplevel = 1L,
  return_gobject = TRUE,
  verbose = NULL,
  ...
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- vars_use:

  character vector. Which variable(s) in metadata for harmony to remove

- reduction:

  reduction on cells or features

- dim_reduction_to_use:

  use another dimension reduction set as input

- dim_reduction_name:

  name of dimension reduction set to use

- dimensions_to_use:

  number of dimensions to use as input

- name:

  arbitrary name for Harmony run

- set_seed:

  use of seed

- seed_number:

  seed number to use

- toplevel_params:

  deprecated

- toplevel:

  relative stackframe where call was made from

- return_gobject:

  boolean: return giotto object (default = TRUE)

- verbose:

  be verbose

- ...:

  additional `HarmonyMatrix` parameters

## Value

giotto object with updated Harmony dimension reduction

## Details

This is a simple wrapper for the HarmonyMatrix function in the Harmony
package
[doi:10.1038/s41592-019-0619-0](https://doi.org/10.1038/s41592-019-0619-0)
.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

runGiottoHarmony(g, vars_use = "leiden_clus")
```
