# Calculate an affine transformation matrix from two sets of landmarks

Calculate an affine transformation matrix from two sets of landmarks.
Source is the item that is transformed to align to target. The The
generated affine transformation matrix is the affine transform that
defines this transformation.

## Usage

``` r
calculateAffineMatrixFromLandmarks(source, target)
```

## Arguments

- source, target:

  `matrix` or `data.frame`-like. Source and target landmarks provided as
  paired x (first) y (second) columns.

## Value

a 3x3 `matrix` that defines an affine transform

## See also

[`interactiveLandmarkSelection()`](https://giottosuite.com/dev/reference/interactiveLandmarkSelection.md)
[`affine()`](https://giotto-suite.github.io/GiottoClass/reference/affine.html)

## Examples

``` r
m1 <- matrix(c(
        4211.476, 4925.052,
        5906.339, 4251.025,
        4830.097, 3342.676,
        5954.410, 3393.603
    ),
    4, 2, byrow = TRUE
)

m2 <- matrix(c(
        7218.570, -11999.111,
        8647.143, -15008.278,
        10150.203, -12953.273,
        10172.141, -15008.059
    ),
    4, 2, byrow = TRUE
)
calculateAffineMatrixFromLandmarks(m1, m2)
```
