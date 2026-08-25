# Warp transformed images from estimated transformation

Warp transformed images from estimated transformation

## Usage

``` r
.warp_transformed_image(x, y, model, outpath = NULL, pkg_ptr)
```

## Arguments

- x:

  source image from .sift_preprocess

- y:

  target image from .sift_preprocess

- model:

  estimated transformation object from
  .estimate_transform_from_matched_descriptor

## Value

None, it will write to a output path
