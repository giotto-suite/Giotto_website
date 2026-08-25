# Lause/Kobak Pearson Residuals Normalization

Calculate Pearson residuals with a dispersion adjustment, to identify
cells that deviate significantly from what would be expected under
independence. The normalization divides by the standard deviation of the
difference, which is adjusted by the dispersion parameter θ.

This normalization is designed for detection of highly variable features
and dimension reduction and clustering.

\$\$\LARGE z\_{i,j} = \frac{x\_{i,j} - \mu\_{i,j}}{\sqrt{\mu\_{i,j} +
\mu\_{i,j}^2 / \theta}} \$\$

\$\$\LARGE \mu\_{i,j} = \frac{r_i \cdot c_j}{N} \$\$

Where:

- (\\x\_{i,j}\\) is the raw count for feature \\i\\ in sample \\j\\

- (\\\mu\_{i,j}\\) is the expected value under the model

- (\\r_i\\) is \\\sum_j x\_{i,j}\\

- (\\c_j\\) is \\\sum_i x\_{i,j}\\

- (\\N\\) is \\\sum\_{i,j} x\_{i,j}\\

- (\\\theta\\) is a dispersion parameter

- (\\z\_{i,j}\\) is the Pearson residual clipped to the range
  \\\[-\sqrt{n}, \sqrt{n}\]\\ where \\n\\ is the number of columns. This
  is done to prevent extreme values from dominating the analysis.

## Value

normalized object

## Note

Scaling is not recommended after this normalization since it is already
transforming the data to z-score-like values with a dispersion
adjustment. It is also not recommended to use this with DGE analysis.

## params

|         |                                                                   |
|---------|-------------------------------------------------------------------|
| `theta` | dispersion parameter expressed as \\\theta\\ in the above formula |

## References

Lause, J., Berens, P. & Kobak, D. Analytic Pearson residuals for
normalization of single-cell RNA-seq UMI data. Genome Biol 22, 258
(2021). https://doi.org/10.1186/s13059-021-02451-7

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
