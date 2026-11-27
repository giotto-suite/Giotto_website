# doCellSegmentation

segment cells in Dapi image

## Usage

``` r
doCellSegmentation(
  raster_img,
  folder_path,
  reduce_resolution = 4,
  overlapping_pixels = 50,
  python_path = NULL
)
```

## Arguments

- raster_img:

  raster image; Dapi image of cells

- folder_path:

  character; where to save the file

- reduce_resolution:

  numeric; the original Dapi image from Vizgen works better in the
  Mesmer algorithm if its resolution is reduced 4 times.

- overlapping_pixels:

  numeric; the number of pixels to overlap when calculating the rolling
  window

- python_path:

  \`NULL\` (default): deepcell is installed on first use and run in a
  worker R session (\`GiottoUtils::py_run()\`); or the path to a Python
  executable that has deepcell installed

## Value

segmentation results

## Details

This function is a wrapper for the Mesmer algorithm implemented in
python. It segments the cells in tissue by applying a rolling window on
the complete image. It saves all the files in the specified folder with
the coordinates of the tile: sx (start x), ex (end x), sy, and ey.
