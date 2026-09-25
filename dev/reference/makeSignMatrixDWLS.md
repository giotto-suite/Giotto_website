# Build a DWLS signature matrix from a Giotto object

Convert expression held in a Giotto object into the mean-expression
reference
[`runDWLSDeconv`](https://giottosuite.com/dev/reference/runDWLSDeconv.md)
expects: signature features by cell type, each entry the mean expression
of that feature in that type. A vector for `cell_type_vector` can be
taken from the cell metadata
([`pDataDT`](https://giotto-suite.github.io/GiottoClass/reference/pDataDT.html)).

## Usage

``` r
makeSignMatrixDWLS(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  reverse_log = TRUE,
  log_base = 2,
  sign_gene,
  cell_type_vector,
  cell_type = NULL
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- expression_values:

  character. Which expression values to use, e.g. "normalized". A
  method's own default is shown in its Usage section.

- reverse_log:

  reverse a log-normalized expression matrix

- log_base:

  the logarithm base (default = 2)

- sign_gene:

  features to use, typically differentially expressed ones

- cell_type_vector:

  vector with cell types (length = ncol(matrix))

- cell_type:

  deprecated, use `cell_type_vector`

## Value

matrix of mean expression, features by cell type

## See also

[`runDWLSDeconv`](https://giottosuite.com/dev/reference/runDWLSDeconv.md)

Other spatial deconvolution:
[`makeSignMatrixDWLSfromMatrix()`](https://giottosuite.com/dev/reference/makeSignMatrixDWLSfromMatrix.md),
[`runDWLSDeconv()`](https://giottosuite.com/dev/reference/runDWLSDeconv.md),
[`runSpatialDeconv()`](https://giottosuite.com/dev/reference/runSpatialDeconv.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
sign_gene <- c(
    "Bcl11b", "Lmo1", "F3", "Cnih3", "Ppp1r3c", "Rims2", "Gfap",
    "Gjc3", "Chrna4", "Prkcd", "Prr18", "Grb14", "Tprn", "Clic1", "Olig2",
    "Hrh3", "Tmbim1", "Carhsp1", "Tmem88b", "Ugt8a", "Arpp19", "Lamp5",
    "Galnt6", "Hlf", "Hs3st2", "Tbr1", "Myl4", "Cygb", "Ttc9b", "Ipcef1"
)

makeSignMatrixDWLS(
    gobject = g, sign_gene = sign_gene,
    cell_type_vector = pDataDT(g)[["leiden_clus"]]
)
```
