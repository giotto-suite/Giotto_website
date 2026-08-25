# Match image descriptors

Brute force matching of descriptors using scikit-image. Find matching
image descriptors between moving images and a target image.

## Usage

``` r
.match_descriptor(
  descriptor_list,
  target_idx = 1L,
  cross_check = TRUE,
  max_ratio = 0.8,
  ...,
  pkg_ptr
)
```

## Arguments

- descriptor_list:

  list of descriptor matrices

- target_idx:

  which item in the list is the target image. Default is 1

- cross_check:

  whether to check that only the best match is returned

- max_ratio:

  Maximum ratio of distances between first and second closest descriptor
  in the second set of descriptors. This threshold is useful to filter
  ambiguous matches between the two descriptor sets. The choice of this
  value depends on the statistics of the chosen descriptor, e.g., for
  SIFT descriptors a value of 0.8 is usually chosen, see D.G. Lowe,
  "Distinctive Image Features from Scale-Invariant Keypoints",
  International Journal of Computer Vision, 2004.

- ...:

  additional params to pass to \`skimage.feature.match_descriptors()\`

## Value

list
