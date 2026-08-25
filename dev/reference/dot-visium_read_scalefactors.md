# Read Visium ScaleFactors

Read Visium ScaleFactors

## Usage

``` r
.visium_read_scalefactors(json_path = NULL)
```

## Arguments

- json_path:

  path to scalefactors_json.json for Visium experimental data

## Value

scalefactors within the provided json file as a named list, or NULL if
not discovered

## Details

asserts the existence of and reads in a .json file containing
scalefactors for Visium data in the expected format. Returns NULL if no
path is provided or if the file does not exist.
