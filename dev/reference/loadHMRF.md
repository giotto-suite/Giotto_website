# loadHMRF

load previous HMRF

## Usage

``` r
loadHMRF(
  name_used = "test",
  output_folder_used,
  k_used = 10,
  betas_used,
  python_path_used
)
```

## Arguments

- name_used:

  name of HMRF that was run

- output_folder_used:

  output folder that was used

- k_used:

  number of HMRF domains that was tested

- betas_used:

  betas that were tested

- python_path_used:

  python path that was used

## Value

reloads a previous ran HMRF from doHRMF

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
x <- tempdir()
doHMRF(g,
    spatial_genes = c("Gna12", "Ccnd2"), output_folder = x,
    betas = c(0, 2, 50)
)

loadHMRF(
    output_folder_used = x, betas_used = c(0, 2, 50),
    python_path_used = NULL
)
```
