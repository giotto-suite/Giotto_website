# normalizeGiotto

fast normalize and/or scale expression values of Giotto object

## Usage

``` r
normalizeGiotto(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = "raw",
  norm_methods = c("standard", "pearson_resid", "osmFISH", "quantile"),
  library_size_norm = TRUE,
  scalefactor = 6000,
  log_norm = TRUE,
  log_offset = 1,
  logbase = 2,
  scale_feats = TRUE,
  scale_genes = deprecated(),
  scale_cells = TRUE,
  scale_order = c("first_feats", "first_cells"),
  theta = 100,
  name = "scaled",
  update_slot = deprecated(),
  verbose = TRUE
)
```

## Arguments

- gobject:

  `giotto` object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- expression_values:

  expression values to use

- norm_methods:

  normalization method to use

- library_size_norm:

  normalize cells by library size

- scalefactor:

  scale factor to use after library size normalization

- log_norm:

  transform values to log-scale

- log_offset:

  offset value to add to expression matrix, default = 1

- logbase:

  log base to use to log normalize expression values

- scale_feats:

  z-score genes over all cells

- scale_genes:

  deprecated, use scale_feats

- scale_cells:

  z-score cells over all genes

- scale_order:

  order to scale feats and cells

- theta:

  theta parameter for the pearson residual normalization step

- name:

  character. name to use for normalization results

- update_slot:

  deprecated. Use `name` param instead

- verbose:

  be verbose

## Value

`giotto` object

## Details

Currently there are two 'methods' to normalize your raw counts data.

A. The standard method follows the standard protocol which can be
adjusted using the provided parameters and follows the following
order:  

- 1\. Data normalization for total library size and scaling by a custom
  scale-factor.

- 2\. Log transformation of data.

- 3\. Z-scoring of data by genes and/or cells.

B. The normalization method as provided by the osmFISH paper is also
implemented:  

- 1\. First normalize genes, for each gene divide the counts by the
  total gene count and multiply by the total number of genes.

- 2\. Next normalize cells, for each cell divide the normalized gene
  counts by the total counts per cell and multiply by the total number
  of cells.

C. The normalization method as provided by Lause/Kobak et al is also
implemented:  

- 1\. First calculate expected values based on Pearson correlations.

- 2\. Next calculate z-scores based on observed and expected values.

D. Quantile normalization across features

- 1\. Rank feature expression

- 2\. Define a common distribution by sorting expression values per
  feature then finding the mean across all features per index

- 3\. Apply common distribution to expression information by using the
  ranks from step 1 as indices

By default the latter two results will be saved in the Giotto slot for
scaled expression, this can be changed by changing the update_slot
parameters

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

normalizeGiotto(g) # default is method A
```
