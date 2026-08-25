# addHMRF

Add selected results from doHMRF to the giotto object

## Usage

``` r
addHMRF(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  HMRFoutput,
  k = NULL,
  betas_to_add = NULL,
  hmrf_name = NULL
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- HMRFoutput:

  HMRF output from doHMRF()

- k:

  number of domains

- betas_to_add:

  results from different betas that you want to add

- hmrf_name:

  specify a custom name

## Value

giotto object

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
spat_genes <- binSpect(g)

output_folder <- file.path(tempdir(), "HMRF")
if (!file.exists(output_folder)) dir.create(output_folder, recursive = TRUE)

out <- doHMRF(
    g,
    spatial_genes = spat_genes[seq_len(20)]$feats,
    expression_values = "scaled",
    spatial_network_name = "Delaunay_network",
    k = 6, betas = c(0, 10, 5),
    output_folder = output_folder
)

g <- addHMRF(
    gobject = g,
    HMRFoutput = out,
    k = 6,
    betas_to_add = 20,
    hmrf_name = "HMRF"
)

spatPlot(
    gobject = g, cell_color = "HMRF_k6_b.20",
)
```
