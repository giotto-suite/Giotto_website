# makeSignMatrixRank

Function to convert a single-cell count matrix and a corresponding
single-cell cluster vector into a rank matrix that can be used with the
Rank enrichment option.

## Usage

``` r
makeSignMatrixRank(
  sc_matrix,
  sc_cluster_ids,
  ties_method = c("random", "max"),
  gobject = NULL
)
```

## Arguments

- sc_matrix:

  matrix of single-cell RNAseq expression data

- sc_cluster_ids:

  vector of cluster ids

- ties_method:

  how to handle rank ties

- gobject:

  if giotto object is given then only genes present in both datasets
  will be considered

## Value

matrix

## See also

`rankEnrich`

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

makeSignMatrixRank(
    sc_matrix = sign_matrix,
    sc_cluster_ids = c("cell_type1", "cell_type2", "cell_type3")
)
```
