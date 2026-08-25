# Default Giotto Normalization

Expression matrix normalization method.

Steps:

1.  [Total library
    size](https://giottosuite.com/dev/reference/norm_library.md)
    normalization and scaling by a custom scale-factor.

2.  [Log](https://giottosuite.com/dev/reference/norm_log.md)
    transformation of data.

## Value

normalized object

## params

|  |  |
|----|----|
| `library_size_norm` | logical (default = `TRUE`). whether to perform library size normalization |
| `scalefactor` | numeric (default = 6000). Scalefactor to use after library size normalization. (skipped if `library_size_norm = FALSE`) |
| `log_norm` | logical (default = `TRUE`). Whether to transform values to log-scale. |
| `log_offset` | numeric (default = 1). If `log_norm = TRUE`, offset value to add to expression values to avoid `log(0)`. Note: for sparse-like matrices (e.g. `dgCMatrix`, 'dbSparseMatrix'), only `log_offset = 1` is supported (log1p) |
| `logbase` | numeric (default = 2). If `log_norm = TRUE`, log base to use to log normalize expression values |

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other normalization parameters:
[`norm_arcsinh`](https://giottosuite.com/dev/reference/norm_arcsinh.md),
[`norm_l2`](https://giottosuite.com/dev/reference/norm_l2.md),
[`norm_library`](https://giottosuite.com/dev/reference/norm_library.md),
[`norm_log`](https://giottosuite.com/dev/reference/norm_log.md),
[`norm_osmfish`](https://giottosuite.com/dev/reference/norm_osmfish.md),
[`norm_pearson`](https://giottosuite.com/dev/reference/norm_pearson.md),
[`norm_quantile`](https://giottosuite.com/dev/reference/norm_quantile.md),
[`norm_tfidf`](https://giottosuite.com/dev/reference/norm_tfidf.md)
