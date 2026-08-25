# addHMRF_V2

function to add HMRF Domain Type to cell meta data

## Usage

``` r
addHMRF_V2(gobject, HMRFoutput, name = "hmrf")
```

## Arguments

- gobject:

  giotto object

- HMRFoutput:

  result object from HMRF model

- name:

  name of HMRF models

## Value

giotto object

## Details

This function appends HMRF domain clusters to corresponding cell meta
data for all the beta values, with the given HMRF model names. For
example, if name = ‘hmrf1’ and name of result in HMRFoutput is ‘k=8
b=0.00’, the appended cell meta data column will be named with ‘hmrf1
k=8 b=0.00’

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
g <- binSpect(g, return_gobject = TRUE)
HMRF_init_obj <- initHMRF_V2(gobject = g, cl.method = "km")
HMRFoutput <- doHMRF_V2(HMRF_init_obj = HMRF_init_obj, betas = c(0, 5, 2))

addHMRF_V2(gobject = g, HMRFoutput = HMRFoutput)
```
