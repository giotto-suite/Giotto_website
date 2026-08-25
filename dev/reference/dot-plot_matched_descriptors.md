# plot matched descriptors

A wrapper function for the plot_matches for the SIFT feature extractor
and descriptor pipeline

## Usage

``` r
.plot_matched_descriptors(x, y, keypoints1, keypoints2, match, pkg_ptr)
```

## Arguments

- x:

  source image from .sift_preprocess

- y:

  target image from .sift_preprocess

- keypoints1:

  keypoints extracted from target image via .sift_detect

- match:

  a 2 col matrix of x to y index matched descriptors via
  .match_descriptor_single

## Value

None
