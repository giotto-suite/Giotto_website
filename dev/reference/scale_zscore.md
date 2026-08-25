# Z Score Scaling

Wrapper around [`base::scale()`](https://rdrr.io/r/base/scale.html) to
make it compatible with the
[`processData()`](https://giottosuite.com/dev/reference/processData.md)
framework. Additionally provides a `MARGIN` param.

\$\$\LARGE z\_{i,j} = \frac{x\_{i,j} - \mu_i}{\sigma_i} \$\$

Where:

- \\x\_{i,j}\\ is the original value for feature \\i\\ in sample \\j\\

- \\\mu_i\\ is the mean of feature \\i\\ across all samples

- \\\sigma_i\\ is the standard deviation of feature \\i\\ across all
  samples

- \\z\_{i,j}\\ is the resulting scaled value

## Value

scaled object

## params

|  |  |
|----|----|
| `scale` | logical (default = `TRUE`) Whether to scale values |
| `center` | logical (default = `TRUE`) Whether to center values |
| `MARGIN` | numeric. Either 1 (rows) or 2 (cols). Direction along which to perform the operation. |

## See also

[process_param](https://giottosuite.com/dev/reference/process_param.md)

Other scaling parameters:
[`scale_default`](https://giottosuite.com/dev/reference/scale_default.md)
