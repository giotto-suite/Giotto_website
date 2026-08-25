# Estimate affine transformation from matched descriptor

Estimate affine transformation from matched descriptor

## Usage

``` r
.estimate_transform_from_matched_descriptor(
  keypoints1,
  keypoints2,
  match,
  estimate_fun,
  ...,
  pkg_ptr
)
```

## Arguments

- keypoints1:

  keypoints extracted from target image via .sift_detect

- match:

  a 2 col matrix of x to y index matched descriptors via
  .match_descriptor_single

## Value

a list of model and inliners
