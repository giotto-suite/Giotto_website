# perform Stardist segmentation

Perform the Giotto wrapper of Stardist 2D segmentation. This is for a
model inference to generate segmentation mask file from input image.
main parameters needed

## Usage

``` r
doStardistSegmentation(
  input,
  mask_output,
  python_env = "giotto_segmentation",
  model_name = "2D_versatile_fluo",
  nuclei_channel = NULL,
  prob_thresh = NULL,
  nms_thresh = NULL,
  verbose = NULL,
  ...
)
```

## Arguments

- input:

  character, required. Provide a path to an image.

- mask_output:

  required. Provide a path to the output mask file.

- python_env:

  python environment with Stardist installed. default =
  "giotto_segmentation". See Stardist official website for more details.

- model_name:

  Name of the model to run inference. Default to '2D_versatile_fluo'. If
  using HE model, input image must be RGB, else the nuclei_channel must
  be given

- nuclei_channel:

  Required using IF based nuclei segmentation, channel number of the
  nuclei staining.

- prob_thresh:

  prob_thresh for model (if not given use model default)

- nms_thresh:

  nms_thresh for model (if not given use model default)

## Value

No return variable, as this will write directly to output path provided.

## Examples

``` r
doStardistSegmentation(
    input = input_image,
    mask_output = output,
    model_name = "2D_versatile_fluo",
    nuclei_channel = 3
)
```
