# Quantile Normalization

Quantile normalization makes the statistical distribution of values in
each column identical by replacing the original values with the mean of
the values at the same rank across all columns. This removes technical
variation while preserving relative differences between features.

Steps:

1.  Rank the values within each column (average taken in case of ties)

2.  Calculate the mean of values at the same rank across all columns

3.  Replace each value with the mean value corresponding to its rank

\$\$\LARGE q\_{i,j} = \bar{x}\_{rank(i,j)} \$\$

Where:

- (\\rank(i,j)\\) is the rank of feature \\i\\ within column \\j\\

- (\\\bar{x}\_{r}\\) where \\r = rank(i,j)\\ is the mean of values with
  rank \\r\\ across all columns

- (\\q\_{i,j}\\) is the quantile-normalized value

## Value

normalized object

## Note

Library normalization and log normalization is recommended prior to this
normalization.

## params

None

## References

Bolstad, B.M., Irizarry, R.A., Astrand, M. et al. A comparison of
normalization methods for high density oligonucleotide array data based
on variance and bias. Bioinformatics 19, 185–193 (2003).
https://doi.org/10.1093/bioinformatics/19.2.185

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
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
