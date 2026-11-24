# Centred Log-Ratio Normalization

Centred log-ratio across the features of each cell, introduced for
antibody-derived tags in CITE-seq (Stoeckius et al. 2017) and used for
protein intensities. It removes each cell's overall brightness.

\$\$\LARGE x'\_{i,j} = \log\left(1 + \frac{x\_{i,j}}{g_j}\right) \$\$

Where:

- (\\x\_{i,j}\\) is the raw intensity for feature \\i\\ in cell \\j\\

- (\\g_j\\) is the geometric mean of \\x\_{i,j} + 1\\ over the features
  of cell \\j\\

## Value

normalized object

## Note

Stoeckius et al. define the centred log-ratio as \\\log((x\_{i,j} + 1) /
g_j)\\. This is the form of established packages: \\g_j\\ is added
before the log instead of 1, so values are never negative, 0 stays 0,
features below the cell's geometric mean (mostly background) are
compressed toward 0, and features well above it get nearly the published
values.

## References

Stoeckius, M., Hafemeister, C., Stephenson, W. et al. Simultaneous
epitope and transcriptome measurement in single cells. Nat Methods 14,
865-868 (2017). https://doi.org/10.1038/nmeth.4380

## See also

[`process_param()`](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_gamma_pearson`](https://giottosuite.com/dev/reference/norm_gamma_pearson.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
