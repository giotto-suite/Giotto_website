# Gamma GLM Pearson Residual Normalization

Pearson residuals of a per-feature Gamma GLM with log link and each
cell's total intensity as offset, after clipping each feature at
quantiles, as in Bruker's reference code for CosMx protein
(`pearson_normalize_gamma_glm()` in the CosMx Analysis Scratch Space).
The intercept-only model has a closed form:

\$\$\LARGE x'\_{i,j} = \frac{x\_{i,j}}{s_j \mu_i} - 1 \$\$

Where:

- (\\x\_{i,j}\\) is the clipped intensity for feature \\i\\ in cell
  \\j\\

- (\\s_j\\) is \\\exp(\max(\log t_j, 0))\\, with \\t_j\\ the cell's
  total intensity before clipping

- (\\\mu_i\\) is the mean of \\x\_{i,j} / s_j\\ over cells

A feature that is 0 in every cell is set to 0, with a warning.

## Value

normalized object

## params

|  |  |
|----|----|
| `clip_quantile` | numeric (default = `c(0.01, 0.99)`). Per-feature lower and upper quantiles at which intensities are clipped; one value is the upper quantile, `c(0, 1)` switches clipping off. |

## References

Bruker Spatial Biology. CosMx Analysis Scratch Space, scPearsonPCA:
`pearson_normalize_gamma_glm()`.
https://github.com/Nanostring-Biostats/CosMx-Analysis-Scratch-Space

## See also

[`process_param()`](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_clr`](https://giottosuite.com/dev/reference/norm_clr.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
