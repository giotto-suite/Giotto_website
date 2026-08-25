# osmFISH Normalization

Normalization method as provided by the osmFISH paper

Steps:

1.  First normalize genes, for each gene divide the counts by the total
    gene count and multiply by the total number of genes.

2.  Next normalize cells, for each cell divide the normalized gene
    counts by the total counts per cell and multiply by the total number
    of cells.

\$\$\LARGE x'\_{i,j} = \frac{x\_{i,j}}{\sum_j x\_{i,j}} \times
n\_{\text{features}} \$\$

\$\$\LARGE x''\_{i,j} = \frac{x'\_{i,j}}{\sum_i x'\_{i,j}} \times
n\_{\text{samples}} \$\$

Where:

- (\\x\_{i,j}\\) is the raw count for feature \\i\\ in sample \\j\\

- (\\x'\_{i,j}\\) is the feature normalized expression value

- (\\x''\_{i,j}\\) is the final normalized expression value after both
  feature and cell normalization

- (\\n\_{\text{samples}}\\) is the total number of cells (columns in
  matrix)

- (\\n\_{\text{features}}\\) is the total number of cells (rows in
  matrix)

## Value

normalized object

## params

None

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
