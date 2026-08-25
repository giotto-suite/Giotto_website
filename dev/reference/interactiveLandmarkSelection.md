# Record landmarks by interactive selection

Interactively select manual paired landmarks.

## Usage

``` r
interactiveLandmarkSelection(source, target)
```

## Arguments

- source:

  the image to be plotted on the left, and landmarks will output in the
  first of the list. Input can be a ggplot object, a
  `giottoLargeImage`-inheriting object, or a character filepath to an
  image

- target:

  the image to be plotted on the right, and landmarks will output in the
  second of the list. Input can be a ggplot object, a
  `giottoLargeImage`-inheriting object, or a character filepath to an
  image

## Value

a list of 2 `data.frames` with columns x and y, designating paired sets
of landmarks between list 1 (from source) and list 2 (from target)

## See also

[`calculateAffineMatrixFromLandmarks()`](https://giottosuite.com/dev/reference/calculateAffineMatrixFromLandmarks.md)
