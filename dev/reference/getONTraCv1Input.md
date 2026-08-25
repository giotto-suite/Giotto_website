# getONTraCv1Input

generate the input data for ONTraC v1

## Usage

``` r
getONTraCv1Input(
  gobject,
  cell_type,
  output_path = getwd(),
  spat_unit = NULL,
  feat_type = NULL,
  verbose = TRUE
)
```

## Arguments

- gobject:

  giotto object

- cell_type:

  the cell type column name in the metadata

- output_path:

  the path to save the output file

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- verbose:

  be verbose

## Value

data.table with columns: Cell_ID, Sample, x, y, Cell_Type

## Details

This function generate the input data for ONTraC v1

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

getONTraCv1Input(
    gobject = g,
    cell_type = "custom_leiden"
)
```
