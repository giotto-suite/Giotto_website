# makeSignMatrixDWLS

Function to convert a matrix within a Giotto object into a format that
can be used with
[`runDWLSDeconv`](https://giottosuite.com/dev/reference/runDWLSDeconv.md)
for deconvolution. A vector of cell types for parameter
`cell_type_vector` can be created from the cell metadata
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

  Giotto object of single cell

- spat_unit:

  spatial unit

- feat_type:

  feature type to use

- expression_values:

  expression values to use

- reverse_log:

  reverse a log-normalized expression matrix

- log_base:

  the logarithm base (default = 2)

- sign_gene:

  all of DE genes (signature)

- cell_type_vector:

  vector with cell types (length = ncol(matrix))

- cell_type:

  deprecated, use `cell_type_vector`

## Value

matrix

## See also

[`runDWLSDeconv`](https://giottosuite.com/dev/reference/runDWLSDeconv.md)

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
