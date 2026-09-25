# Build a rank signature matrix

Convert a single-cell count matrix and its cluster assignments into the
rank matrix
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md)
expects.

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

  how to rank tied expression values, `"average"` (default) or `"max"`

- gobject:

  giotto object. When given, only features present in both datasets are
  kept.

## Value

matrix

## See also

[`runRankEnrich`](https://giottosuite.com/dev/reference/runRankEnrich.md)

Other feature set enrichment:
[`enrich_hyper`](https://giottosuite.com/dev/reference/enrich_hyper.md),
[`enrich_page`](https://giottosuite.com/dev/reference/enrich_page.md),
[`enrich_param`](https://giottosuite.com/dev/reference/enrich_param.md),
[`enrich_rank`](https://giottosuite.com/dev/reference/enrich_rank.md),
[`enrichment_PAGE`](https://giottosuite.com/dev/reference/enrichment_PAGE.md),
[`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md),
[`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md),
[`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)

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
