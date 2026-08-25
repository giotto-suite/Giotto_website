# doScrubletDetect

Run *scrublet* doublet detection for raw expression. Intended for single
cell data

## Usage

``` r
doScrubletDetect(
  gobject,
  feat_type = NULL,
  spat_unit = "cell",
  expression_values = "raw",
  expected_doublet_rate = 0.06,
  min_counts = 1,
  min_cells = 1,
  min_gene_variability_pctl = 85,
  n_prin_comps = 30,
  return_gobject = TRUE,
  seed = 1234
)
```

## Arguments

- gobject:

  giotto object containing expression data

- feat_type:

  feature type

- spat_unit:

  spatial unit

- expression_values:

  expression values to use

- expected_doublet_rate:

  expected transcriptomes that are doublets. 0.06 is from 10x Chromium
  guide.

- min_counts:

  scrublet internal data filtering, min counts found to be considered a
  cell

- min_cells:

  scrublet internal data filtering. min cells expressed to be considered
  a feat

- min_gene_variability_pctl:

  scrublet internal PCA generation. highly variable gene percentile
  cutoff

- n_prin_comps:

  number of PCs to use in PCA for detection

- return_gobject:

  return as gobject if TRUE, data.frame with cell_ID if FALSE

- seed:

  If a numeric is provided, then it will be used as a seed. If NULL, no
  seed will be set.

## Value

if `return_gobject = FALSE`, a `data.table` cell_ID, doublet scores, and
classifications are returned. If `TRUE`, that information is appended
into the input `giotto` object's metadata and the `giotto` object is
returned.

## See also

This function wraps the python package scrublet
[doi:10.1016/j.cels.2018.11.005](https://doi.org/10.1016/j.cels.2018.11.005)

## Examples

``` r
# Should only be done with single cell data, but this is just a
# convenient example.
g <- GiottoData::loadGiottoMini("visium")

g <- doScrubletDetect(g)

pDataDT(g) # doublet_scores and doublet cols are added
dimPlot2D(g, cell_color = "doublet_scores", color_as_factor = FALSE)
```
