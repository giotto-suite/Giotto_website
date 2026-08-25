# perform cellpose segmentation

Perform the Giotto Wrapper of cellpose segmentation. This is for a model
inference to generate segmentation mask file from input image. main
parameters needed

## Usage

``` r
doCellposeSegmentation(
  input,
  mask_output,
  python_env = "giotto_segmentation",
  channel_1 = 0,
  channel_2 = 0,
  model_name = "cyto3",
  batch_size = 8,
  resample = TRUE,
  channel_axis = NULL,
  z_axis = NULL,
  normalize = TRUE,
  invert = FALSE,
  rescale = NULL,
  diameter = NULL,
  flow_threshold = 0.4,
  cellprob_threshold = 0,
  do_3D = FALSE,
  anisotropy = NULL,
  stitch_threshold = 0,
  min_size = 15,
  max_size_fraction = 0.4,
  niter = NULL,
  augment = FALSE,
  tile_overlap = 0.1,
  bsize = 224,
  dP_smooth = 0L,
  interp = TRUE,
  compute_masks = TRUE,
  progress = NULL,
  verbose = NULL,
  ...
)
```

## Arguments

- input:

  character, required. Provide a path to a gray scale or a three channel
  image.

- mask_output:

  required. Provide a path to the output mask file.

- channel_1:

  channel number for cytoplasm, default to 0(gray scale)

- channel_2:

  channel number for Nuclei, default to 0(gray scale)

- model_name:

  Name of the model to run inference. Default to 'cyto3', if you want to
  run cutomized trained model, place your model file in
  ~/.cellpose/models and specify your model name.

- batch_size:

  Cellpose Parameter, Number of 224x224 patches to run simultaneously on
  the GPU. Can make smaller or bigger depending on GPU memory usage.
  Defaults to 8.

- resample:

  (logical, optional) – run dynamics at original image size (will be
  slower but create more accurate boundaries). Defaults to True.

- channel_axis:

  (int, optional) – channel axis in element of list x, or of
  np.ndarray x. if NULL, channels dimension is attempted to be
  automatically determined. Defaults to NULL.

- z_axis:

  (int, optional) – z axis in element of list x, or of np.ndarray x. if
  NULL, z dimension is attempted to be automatically determined.
  Defaults to NULL.

- normalize:

  Logical or list. Controls image normalization: If TRUE, normalizes to
  1st-99th percentile Can be a list with parameters: \* lowhigh: Numeric
  vector c(low, high) for manual normalization values \* sharpen:
  Numeric, image sharpening factor (1/4-1/8 of cell diameter in pixels)
  \* normalize: Logical, whether to run normalization \* percentile:
  Numeric vector c(low_perc, high_perc) \* tile_norm: Integer, window
  size in pixels for tile normalization \* norm3D: Logical, normalize
  across full z-stack Default: TRUE

- invert:

  Logical. Inverts pixel intensity before processing. Default: FALSE

- rescale:

  Numeric. Resize factor for images. Default: NULL (sets to 1.0)

- diameter:

  Numeric. Cell diameter for each image. Default: NULL (uses diam_mean
  or diam_train if available)

- flow_threshold:

  Numeric. Flow error threshold for cell retention (2D only). Default:
  0.4

- cellprob_threshold:

  Numeric. Threshold for mask pixel retention. Default: 0.0

- do_3D:

  Logical. Enable 3D segmentation for 3D/4D inputs. Default: FALSE

- anisotropy:

  Numeric. Z-axis rescaling factor for 3D segmentation. Default: NULL

- stitch_threshold:

  Numeric. Threshold for 3D mask stitching (2D mode only). Default: 0.0

- min_size:

  Integer. Minimum ROI size in pixels. Default: 15

- max_size_fraction:

  Numeric. Maximum mask size as fraction of image. Default: 0.4

- niter:

  Integer. Number of dynamics computation iterations. Default: NULL (set
  based on diameter)

- augment:

  Logical. Enable tile augmentation with overlapping. Default: FALSE

- tile_overlap:

  Numeric. Tile overlap fraction for flow computation. Default: 0.1

- bsize:

  Integer. Block size for tiles (recommended: 224). Default: 224

- dP_smooth:

  Integer. Gaussian smoothing standard deviation for 3D flows.

- interp:

  Logical. Enable interpolation for 2D dynamics. Default: TRUE

- compute_masks:

  Logical. Compute dynamics and return masks. Default: TRUE

- progress:

  progress bar. Defaults to NULL

- python_path:

  python environment with cellpose installed. default =
  "giotto_segmentation".

## Value

No return variable, as this will write directly to output path provided.

## Examples

``` r
doCellposeSegmentation(
    input = input_image,
    mask_output = output, channel_1 = 2,
    channel_2 = 1, model_name = "cyto3", batch_size = 4
)
```
