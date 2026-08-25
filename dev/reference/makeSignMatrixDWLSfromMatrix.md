# makeSignMatrixDWLSfromMatrix

Function to convert a single-cell RNAseq matrix into a format that can
be used with
[`runDWLSDeconv`](https://giottosuite.com/dev/reference/runDWLSDeconv.md).

## Usage

``` r
makeSignMatrixDWLSfromMatrix(matrix, sign_gene, cell_type_vector)
```

## Arguments

- matrix:

  scRNA-seq matrix

- sign_gene:

  genes to use (e.g. marker genes)

- cell_type_vector:

  vector with cell types (length = ncol(matrix))

## Value

matrix

## See also

[`runDWLSDeconv`](https://giottosuite.com/dev/reference/runDWLSDeconv.md)

## Examples

``` r
sign_gene <- c(
    "Bcl11b", "Lmo1", "F3", "Cnih3", "Ppp1r3c", "Rims2", "Gfap",
    "Gjc3", "Chrna4", "Prkcd", "Prr18", "Grb14", "Tprn", "Clic1", "Olig2",
    "Hrh3", "Tmbim1", "Carhsp1", "Tmem88b", "Ugt8a", "Arpp19", "Lamp5",
    "Galnt6", "Hlf", "Hs3st2", "Tbr1", "Myl4", "Cygb", "Ttc9b", "Ipcef1"
)

sign_matrix <- matrix(rnorm(length(sign_gene) * 3), nrow = length(sign_gene))
rownames(sign_matrix) <- sign_gene
colnames(sign_matrix) <- c("cell_type1", "cell_type2", "cell_type3")

makeSignMatrixDWLSfromMatrix(
    matrix = sign_matrix, sign_gene = sign_gene,
    cell_type_vector = c("cell_type1", "cell_type2", "cell_type3")
)
```
