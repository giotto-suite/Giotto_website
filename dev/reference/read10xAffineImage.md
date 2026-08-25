# read10xAffineImage

Read a 10x image that is provided with an affine matrix transform. Loads
the image in with an orientation that matches the dataset points and
polygons vector information

## Usage

``` r
read10xAffineImage(
  file,
  imagealignment_path,
  name = "aligned_image",
  micron = 0.2125,
  ...
)
```

## Arguments

- file:

  filepath to image

- imagealignment_path:

  filepath to alignment file which contains an affine transformation
  matrix. Usually a `.csv` file

- name:

  character. Name to assign the image. Default is 'image'.

- micron:

  micron scaling. Directly used if a numeric is supplied. Also prefers a
  filepath to the `experiment.xenium` file which contains this info. A
  default of 0.2125 is provided.

- ...:

  additional params to pass to `[GiottoClass::createGiottoLargeImage]`

## Value

10xAffineImage
