# Library Size Normalization

Normalize expression matrix for total library size and then scale by a
custom scalefactor.

This method does not work well when any cells/samples have a library
size of 0, so filtering prior to this is recommended.

\$\$\LARGE x'\_{i,j} = \frac{x\_{i,j}}{\sum\_{i} x\_{i,j}} \times k \$\$
Where:

- (\\x\_{i,j}\\) is the raw count for feature \\i\\ in sample \\j\\

- (\\x'\_{i,j}\\) is the library normalized and scaled expression value
  for feature \\i\\ in sample \\j\\

- \(k\) is a scalefactor applied after normalization

## Value

normalized object

## params

|  |  |
|----|----|
| `scalefactor` | numeric (default = 6000). Scalefactor to use after library size normalization. Expressed as ***k*** in the above equation |

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
