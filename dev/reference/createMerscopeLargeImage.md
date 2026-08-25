# Create Vizgen MERSCOPE largeImage

Read MERSCOPE stitched images as giottoLargeImage. Images will also be
transformed to match the spatial coordinate reference system of the
paired points and polygon data.

## Usage

``` r
createMerscopeLargeImage(
  image_file,
  transforms_file,
  name = "image",
  flip_axis = c("none", "y", "x", "both")
)
```

## Arguments

- image_file:

  character. Path to one or more MERSCOPE images to load

- transforms_file:

  character. Path to MERSCOPE transforms file. Usually in the same
  folder as the images and named 'micron_to_mosaic_pixel_transform.csv'

- name:

  character. name to assign the image. Multiple should be provided if
  image_file is a list.

- flip_axis:

  character. Axis along which to reflect the image after the spatial
  shift: `"none"` (default), `"y"`, `"x"`, or `"both"`. The reflection
  origin is the midpoint of the image extent in micron space.

## Value

giottoLargeImage
