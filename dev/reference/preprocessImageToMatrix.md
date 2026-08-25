# Preprocess from image directory to the required matrix format for Image registration pipeline built on scikit-image

Preprocess a image path to the required matrix format for Image
registration pipeline built on scikit-image

## Usage

``` r
preprocessImageToMatrix(
  x,
  invert = FALSE,
  equalize_histogram = TRUE,
  flip_vertical = FALSE,
  flip_horizontal = FALSE,
  rotate_90 = FALSE,
  use_single_channel = FALSE,
  single_channel_number = NULL,
  pkg_ptr
)
```

## Arguments

- x:

  input file path, required

- invert:

  whether or not to invert intensity to make calculation of descriptors
  more accurate, default FALSE

- equalize_histogram:

  whether or not to calculate equalized histogram of the image,default
  TRUE

- flip_vertical:

  whether or not to flip vertical, default FALSE

- flip_horizontal:

  whether or not to flip horizontal, default FALSE

- rotate_90:

  whether or not to rotates the image 90 degrees counter-clockwise,
  default FALSE

- use_single_channel:

  If input is a multichannel image, whether or not to extract single
  channel, default FALSE

- single_channel_number:

  Channel number in the multichannel image, required if
  use_single_channel = TRUE

## Value

a matrix array to input to .sift_detect
