# Estimate Automated ImageRegistration With SIFT

Automatically estimate a transform with SIFT feature detection,
descriptor match and returns a transformation object to use

## Usage

``` r
estimateAutomatedImageRegistrationWithSIFT(
  x,
  y,
  plot_match = FALSE,
  max_ratio = 0.6,
  estimate_fun = "affine",
  save_warp = NULL,
  verbose = TRUE
)
```

## Arguments

- x:

  required. Source matrix input, could be generated from
  preprocessImageToMatrix

- y:

  required. Source matrix input, could be generated from
  preprocessImageToMatrix

- plot_match:

  whether or not to plot the matching descriptors. Default False

- max_ratio:

  max_ratio parameter for matching descriptors, default 0.6

- estimate_fun:

  default Affine. The transformation model to use estimation

- save_warp:

  default NULL, if not NULL, please provide an output image path to save
  the warpped image.

## Value

a list of the estimated transformation object

## Examples

``` r
estimation <- estimateAutomatedImageRegistrationWithSIFT(
    x = image_mtx1, y = image_mtx2
)
```
