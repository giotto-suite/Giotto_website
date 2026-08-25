# Create Vizgen MERSCOPE Giotto Object

Given the path to a MERSCOPE experiment directory, creates a Giotto
object. Supports both Parquet and HDF5 cell boundary formats (v2).
Features automatic 2D vs 3D architecture detection with vertex
validation.

## Usage

``` r
createGiottoMerscopeObject(
  merscope_dir,
  version = 1,
  data_to_use = c("subcellular", "aggregate"),
  FOVs = NULL,
  polygon_format = c("parquet", "hdf5"),
  poly_z_indices = NULL,
  flip_axis = c("none", "y", "x", "both"),
  spat_unit = "cell",
  calculate_overlap = TRUE,
  overlap_to_matrix = TRUE,
  aggregate_stack = TRUE,
  aggregate_stack_param = list(summarize_expression = "sum", summarize_locations =
    "mean", new_spat_unit = "cell"),
  split_keyword = c("Blank"),
  instructions = NULL,
  cores = NA,
  verbose = TRUE
)

.createGiottoMerscopeObject_subcellular(
  data_list,
  version = 1,
  flip_axis = c("none", "y", "x", "both"),
  spat_unit = "cell",
  calculate_overlap = TRUE,
  overlap_to_matrix = TRUE,
  aggregate_stack = TRUE,
  aggregate_stack_param = list(summarize_expression = "sum", summarize_locations =
    "mean"),
  split_keyword = c("Blank"),
  instructions = NULL,
  cores = NA,
  verbose = TRUE
)

.createGiottoMerscopeObject_aggregate(data_list, cores = NA, verbose = TRUE)
```

## Arguments

- merscope_dir:

  full path to the exported merscope directory

- version:

  integer. Version of logic to use (1 = Legacy/Original, 2 =
  New/Optimized)

- data_to_use:

  which of either the 'subcellular' or 'aggregate' information to use
  for object creation

- FOVs:

  which FOVs to use when building the subcellular object. (default is
  NULL). NULL loads all FOVs (very slow)

- polygon_format:

  format of the boundary files, either 'parquet' or 'hdf5' (v2 only)

- poly_z_indices:

  which z-indices to use for the polygons (Default 0:6 for v2, 1:7 for
  v1)

- flip_axis:

  character. **Version 2 only.** Axis along which to reflect polygon
  vertices and transcript coordinates after loading: `"none"` (default,
  data read as-is), `"y"`, `"x"`, or `"both"`. The reflection origin is
  the midpoint of the transcript coordinate range so both layers stay
  registered. Silently forced to `"none"` for `version = 1`, which
  handles orientation internally via `polygon_mask_list_params`
  (`flip_vertical = TRUE`).

- spat_unit:

  character. Name assigned to the cell spatial unit (default `"cell"`).
  Controls the polygon layer name when a single Z-plane is present and
  serves as the default `new_spat_unit` in `aggregate_stack_param` when
  that field is not already supplied.

- calculate_overlap:

  whether to run
  [`calculateOverlapRaster`](https://giotto-suite.github.io/GiottoClass/reference/calculateOverlapRaster.html)

- overlap_to_matrix:

  whether to run
  [`overlapToMatrix`](https://giotto-suite.github.io/GiottoClass/reference/overlapToMatrix.html)

- aggregate_stack:

  whether to run `aggregateStacks`

- aggregate_stack_param:

  params to pass to `aggregateStacks`

- split_keyword:

  character vector of keywords to separate feature detections (e.g.
  "Blank")

- instructions:

  list of instructions or output result from
  [`createGiottoInstructions`](https://giotto-suite.github.io/GiottoClass/reference/giotto_instructions.html)

- cores:

  how many cores or threads to use to read data if paths are provided

- verbose:

  be verbose when building Giotto object

- data_list:

  list of loaded data from
  [`load_merscope_folder`](https://giottosuite.com/dev/reference/load_merscope_folder.md)

## Value

a giotto object

## Functions

- `.createGiottoMerscopeObject_subcellular()`: Create giotto object with
  'subcellular' workflow

- `.createGiottoMerscopeObject_aggregate()`: Create giotto object with
  'aggregate' workflow
