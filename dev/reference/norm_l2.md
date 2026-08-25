# L2 Normalization

L2 normalization (also known as Euclidean normalization) scales each
column (sample) in the expression matrix to have unit Euclidean length.
This process makes samples with different sequencing depths more
comparable and improves the performance of distance-based analyses.

\$\$\LARGE x'\_{i,j} = \frac{x\_{i,j}}{\sqrt{\sum\_{i} x\_{i,j}^2}} \$\$

Where:

- (\\x\_{i,j}\\) is the expression value for feature \\i\\ in sample
  \\j\\

- (\\x'\_{i,j}\\) is the L2-normalized expression value

## Value

normalized object

## Note

L2 normalization can be applied to raw data, but is most commonly used
after other normalization methods such as TF-IDF or log normalization to
standardize sample-to-sample comparisons.

## params

None

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
