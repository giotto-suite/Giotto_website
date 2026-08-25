# get10Xmatrix_h5

This function creates an expression matrix from a 10X h5 file path

## Usage

``` r
get10Xmatrix_h5(
  path_to_data,
  gene_ids = c("symbols", "ensembl"),
  remove_zero_rows = TRUE,
  split_by_type = TRUE
)
```

## Arguments

- path_to_data:

  path to the 10X .h5 file

- gene_ids:

  use gene symbols (default) or ensembl ids for the gene expression
  matrix

- remove_zero_rows:

  removes rows with sum equal to zero

- split_by_type:

  split into multiple matrices based on 3rd column of features.tsv(.gz)

## Value

(list of) sparse expression matrix from 10X

## Details

If the .h5 10x file has multiple classes of features (e.g. expression vs
QC probes) or modalities (e.g. RNA and protein), and `split_by_type`
param is `TRUE`, multiple matrices will be returned
