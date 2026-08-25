# Default Giotto Scaling

2 step
[z-scoring](https://giottosuite.com/dev/reference/scale_zscore.md) along
features and samples

## Value

scaled object

## params

|  |  |
|----|----|
| `scale_feats` | logical (default = `TRUE`) Whether to scale across features |
| `scale_cells` | logical (default = `TRUE`) Whether to scale across cells/samples |
| `scale_order` | character. One of either `"first_feats"` or `"first_cells"`. When both `scale_feats` and `scale_cells` are `TRUE`, determines the order in which the 2 scaling operations are performed. |
| `verbose` | logical (default = `TRUE`) Whether to be verbose |

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other scaling parameters:
[`scale_zscore`](https://giottosuite.com/dev/reference/scale_zscore.md)
