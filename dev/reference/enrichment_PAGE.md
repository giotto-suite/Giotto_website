# PAGE feature enrichment

Expression feature-based enrichment scoring of labels.  
A binary matrix of signature features (e.g. for cell types or processes)
can either be directly provided or converted from a list using
`makeSignMatrixPAGE()`. This matrix is then used with `runPAGEEnrich()`
in order to calculate feature signature enrichment scores per spatial
position using PAGE.

## Usage

``` r
makeSignMatrixPAGE(sign_names, sign_list)

runPAGEEnrich(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  sign_matrix,
  expression_values = c("normalized", "scaled", "custom"),
  min_overlap_genes = 5,
  reverse_log_scale = TRUE,
  logbase = 2,
  output_enrichment = c("original", "zscore"),
  p_value = FALSE,
  include_depletion = FALSE,
  n_times = 1000,
  max_block = 2e+07,
  name = NULL,
  verbose = TRUE,
  return_gobject = TRUE
)
```

## Arguments

- sign_names:

  `character` vector with names (labels) for each provided feat
  signature

- sign_list:

  list of feats in signature

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- sign_matrix:

  binary matrix of signature features (rows) by cell type or process
  (columns), 1 where the feature marks the type. Build one with
  `makeSignMatrixPAGE` or
  [`makeSignMatrixRank`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md).

- expression_values:

  character. Which expression values to use, e.g. "normalized". A
  method's own default is shown in its Usage section.

- min_overlap_genes:

  minimum number of overlapping features in `sign_matrix` required to
  calculate enrichment (PAGE)

- reverse_log_scale:

  logical. Undo a log transform before averaging (default = TRUE).

- logbase:

  numeric. Log base to undo when `reverse_log_scale = TRUE` (default =
  2).

- output_enrichment:

  character. "original" (default) or "zscore", which standardizes the
  scores within each cell type.

- p_value:

  logical. Calculate p-values (default = FALSE).

- include_depletion:

  also test for depletion, not enrichment only (default = FALSE)

- n_times:

  number of permutation iterations to calculate p-value

- max_block:

  number of lines to process together (default = 20e6)

- name:

  character. Name to store the result under in the giotto object's
  spatial enrichment slot. `NULL` (default) uses the method's own name –
  see the Usage section.

- verbose:

  be verbose

- return_gobject:

  logical. Return the giotto object with the result added (default =
  TRUE), or the result object on its own.

## Value

`matrix` (`makeSignMatrixPAGE()`) and `giotto`
(`runPAGEEnrich(return_gobject = TRUE)`) or `data.table`
(`runPAGEEnrich(return_gobject = FALSE)`)

## Details

The enrichment Z score is calculated by using method (PAGE) from Kim SY
et al., BMC bioinformatics, 2005 as  
\\Z = ((Sm – mu)\*m^(1/2)) / delta\\.  
For each gene in each spot, mu is the fold change values versus the mean
expression and delta is the standard deviation. Sm is the mean fold
change value of a specific marker gene set and m is the size of a given
marker gene set.

## See also

Other feature set enrichment:
[`enrich_hyper`](https://giottosuite.com/dev/reference/enrich_hyper.md),
[`enrich_page`](https://giottosuite.com/dev/reference/enrich_page.md),
[`enrich_param`](https://giottosuite.com/dev/reference/enrich_param.md),
[`enrich_rank`](https://giottosuite.com/dev/reference/enrich_rank.md),
[`makeSignMatrixRank()`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md),
[`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md),
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md),
[`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

sign_list <- list(
    cell_type1 = c(
        "Bcl11b", "Lmo1", "F3", "Cnih3", "Ppp1r3c",
        "Rims2", "Gfap", "Gjc3", "Chrna4", "Prkcd"
    ),
    cell_type2 = c(
        "Prr18", "Grb14", "Tprn", "Clic1", "Olig2", "Hrh3",
        "Tmbim1", "Carhsp1", "Tmem88b", "Ugt8a"
    ),
    cell_type2 = c(
        "Arpp19", "Lamp5", "Galnt6", "Hlf", "Hs3st2",
        "Tbr1", "Myl4", "Cygb", "Ttc9b", "Ipcef1"
    )
)

sm <- makeSignMatrixPAGE(
    sign_names = c("cell_type1", "cell_type2", "cell_type3"),
    sign_list = sign_list
)

g <- runPAGEEnrich(
    gobject = g,
    sign_matrix = sm,
    min_overlap_genes = 2
)

spatPlot2D(g,
    cell_color = "cell_type2",
    spat_enr_names = "PAGE",
    color_as_factor = FALSE
)
```
