# Run SIFT feature detector and descriptor extractor

Perform feature detector and descriptor extractor on a matrix object or
preprocessed image object

## Usage

``` r
.sift_detect(x, ..., pkg_ptr)
```

## Arguments

- x:

  input matrix or preprocessed image to extract feature and descriptor
  from

- ...:

  additional params to pass to \`skimage.feature.SIFT()\`

## Value

list of keypoints and descriptors
