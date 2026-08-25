# TF-IDF Normalization

TF-IDF (Term Frequency-Inverse Document Frequency) normalization is
borrowed from natural language processing to identify features that are
highly expressed in specific samples but not widely expressed across the
entire dataset.

There are several different implementations that apply log or
binarization to different terms. `sub_method = c(1:3)` and `dgCMatrix`
optimizations are based on the ArchR implementations.

\$\$\LARGE TF\_{i,j} = \frac{x\_{i,j}}{\sum\_{i} x\_{i,j}} \$\$

\$\$\LARGE IDF\_{i} = \frac{n\_{samples}}{\sum\_{j} x\_{i,j}} \$\$

\$\$\LARGE IBDF\_{i} = \frac{n\_{samples}}{1 + n\_{samples \\ where \\
feature \\ i \> 0}} \$\$

**Implementations** (`sub_method`):

\$\$\large (default) \quad TFIDF\_{i,j} = TF\_{i,j} \times
\log(IBDF\_{i} + 1) \$\$

\$\$\large (1) \quad TFIDF\_{i,j} = TF\_{i,j} \times \log(IDF\_{i} + 1)
\$\$

\$\$\large (2) \quad TFIDF\_{i,j} = \log(TF\_{i,j} \times IDF\_{i}
\times S + 1) \quad \$\$

\$\$\large (3) \quad TFIDF\_{i,j} = \log(TF\_{i,j} + 1) \times
\log(IDF\_{i} + 1) \$\$

Where:

- (\\x\_{i,j}\\) is the raw count for feature \\i\\ in sample \\j\\

- (\\TF\_{i,j}\\) is the term frequency of feature \\i\\ in sample \\j\\

- (\\IDF\_{i}\\) is the inverse document frequency of feature \\i\\

- (\\IBDF\_{i}\\) is the inverse binarized document frequency of feature
  \\i\\

- (\\TFIDF\_{i,j}\\) is the final TF-IDF normalized value

- (\\S\\) is a scalefactor (default = 10000)

## Value

normalized object

## Note

[L2](https://giottosuite.com/dev/reference/norm_l2.md) normalization is
commonly performed after TF-IDF normalization

## params

|  |  |
|----|----|
| `sub_method` | Either numeric 1, 2, or 3 or "default". Determines which set of defaults to use during the TF-IDF calculation. Methods 1-3 map to the same `LSIMethod` settings in ArchR. See sub_method section below. |
| `log_tf` | logical (overrides `sub_method` defaults). Whether to log transform TF values (includes a +1 offset). |
| `log_idf` | logical (overrides `sub_method` defaults). Whether to log transform IDF values (includes a +1 offset). |
| `log_tf_idf` | logical (overrides `sub_method` defaults). Whether to log transform the TF-IDF value (also applies a scalefactor (\\s\\) and +1 offset before the log operation). |
| `binarized_rowsums` | logical (overrides `sub_method` defaults). Whether to calculate IBDF instead of IDF, where the calculation is based on the presence of a feature as opposed to its count. |
| `scalefactor` | numeric (default = 10000). A scalefactor used when `log_tf_idf = TRUE`. |

## `sub_method`

`sub_method` can be one of `"default"` or any of the other
implementations from 1 to 3. These apply some defaults to the way that
TF-IDF is calculated. The individual `log_` params will override these
defaults.

- `"default"` - default Giotto implementation:

  - `log_idf = TRUE`

  - `binarized_rowsums = TRUE`

- `1` - Method introduced in Cusanovich et al. 2018.

  - `log_idf = TRUE`

- `2` - Method introduced in Stuart et al. 2021.

  - `log_tf_idf = TRUE`

- `3` - Method 3 in ArchR `iterativeLSI()`

  - `log_tf = TRUE`

  - `log_idf = TRUE`

## References

Cusanovich, D., Reddington, J., Garfield, D. et al. The cis-regulatory
dynamics of embryonic development at single-cell resolution. Nature 555,
538–542 (2018). https://doi.org/10.1038/nature25981

Stuart T, Srivastava A, Madad S, Lareau CA, Satija R. Single-cell
chromatin state analysis with Signac. Nat Methods. 2021
Nov;18(11):1333-1341. doi: 10.1038/s41592-021-01282-5.

Granja JM, Corces MR, Pierce SE, Bagdatli ST, Choudhry H, Chang HY,
Greenleaf WJ. ArchR is a scalable software package for integrative
single-cell chromatin accessibility analysis. Nat Genet. 2021
Mar;53(3):403-411. doi: 10.1038/s41588-021-00790-6.

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md)

## Examples

``` r
e <- GiottoData::loadSubObjectMini("exprObj")
processData(e, normParam("tf-idf"))
processData(e, normParam("tf-idf", sub_method = 1))
processData(e, normParam("tf-idf", sub_method = 2))
processData(e, normParam("tf-idf", sub_method = 3))
```
