# perform Mesmer(Deepcell) segmentation

Perform the Giotto Wrapper of mesmer segmentation. This is for a model
inference to generate segmentation mask file from input image. main
parameters needed

## Usage

``` r
doMesmerSegmentation(
  input,
  mask_output,
  python_env = "giotto_segmentation",
  nucleus_channel = 1,
  membrane_channel = 2,
  micron_scale = 0.25,
  verbose = NULL,
  ...
)
```

## Arguments

- input:

  character, required. Provide a path to a IF image.

- mask_output:

  required. Provide a path to the output mask file.

- python_env:

  python environment with deepcell installed. default =
  "giotto_segmentation". See deepcell official website for more details.

- nucleus_channel:

  channel number for Nuclei, default to 1

- membrane_channel:

  channel number for cell boundary, default to 2

- micron_scale:

  numeric. Multiplicative scalefactor to convert pixel dimensions to
  physical microns.

## Value

No return variable, as this will write directly to output path provided.

## Examples

``` r
doMesmerSegmentation(
    input = input_image,
    mask_output = output,
    nucleus_channel = 1,
    membrane_channel = 2,
    micron_scale = 0.5
)
```
