# Log Normalization

Apply a log normalization

\$\$\LARGE x'\_{i,j} = \frac{\log(x\_{i,j} + b)}{\log(a)} \$\$ Where:

- (\\x\_{i,j}\\) is the raw count for feature \\i\\ in sample \\j\\

- (\\x'\_{i,j}\\) is the log normalized expression value for feature
  \\i\\ in sample \\j\\

- (\\a\\) is the log base

- (\\b\\) is an offset value

## Value

normalized object

## params

|  |  |
|----|----|
| `base` | numeric (default = 2) log base to use. Expressed as \\a\\ in the above equation. |
| `offset` | numeric (default = 1). Offset to add to expression values to avoid \\\log(0)\\. Expressed as \\b\\ in the above equation. For sparse-like matrices and `dbMatrix`, only `offset = 1` is supported; other values would change implicit zeros and require densification. |

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_default`](https://giottosuite.com/dev/reference/norm_default.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
