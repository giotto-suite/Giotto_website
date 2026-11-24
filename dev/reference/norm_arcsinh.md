# Arcsinh Normalization

A normalization commonly used with intensity-based data (CODEX, CyCIF,
IMC). It effectively handles a wide dynamic range and zero/near-zero
values while preserving the relative differences between signals of
different intensities.

\$\$\LARGE x'\_{i,j} =
\operatorname{arcsinh}\left({\frac{x\_{i,j}}{c}}\right) \$\$

Where:

- (\\x\_{i,j}\\) is the raw intensity for feature \\i\\ in sample \\j\\

- (\\x'\_{i,j}\\) is the normalized intensity for feature \\i\\ in
  sample \\j\\

- (\\c\\) is a cofactor that determines the degree of transformation

## Value

normalized object

## Note

The cofactor \\c\\ prevents over-amplification of small values and
allows better differentiation of signals at different intensities.

Common values to use are:

- `c = 5` for fluorescence imaging-based proteomics (CODEX, CyCIF)

- `c = 1` or `5` for mass-cytometry-based imaging (IMC).

## params

|  |  |
|----|----|
| `c` | numeric (default = 5). Expressed as \\c\\ in the above formula: one value, or a value per feature as a named vector, e.g. `c(5, CD45 = 150)`, where the unnamed value applies to the features not named. |

## References

Bendall, S.C., Simonds, E.F., Qiu, P. et al. Single-cell mass cytometry
of differential immune and drug responses across a human hematopoietic
continuum. Science 332, 687-696 (2011).
https://doi.org/10.1126/science.1198704

Nowicka, M., Krieg, C., Crowell, H.L. et al. CyTOF workflow:
differential discovery in high-throughput high-dimensional cytometry
datasets. F1000Research 6, 748 (2017).
https://doi.org/10.12688/f1000research.11622.3

## See also

[`process_param()`](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_clr`](https://giottosuite.com/dev/reference/norm_clr.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_gamma_pearson`](https://giottosuite.com/dev/reference/norm_gamma_pearson.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
