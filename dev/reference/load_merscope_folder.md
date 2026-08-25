# Load MERSCOPE data from folder

Load MERSCOPE data from folder

## Usage

``` r
.load_merscope_folder(
  dir_items,
  data_to_use,
  polygon_format,
  fovs = NULL,
  poly_z_indices = 0:6,
  version = 1,
  cores = NA,
  verbose = TRUE
)

.load_merscope_folder_subcellular(
  dir_items,
  data_to_use,
  polygon_format,
  cores = NA,
  poly_z_indices = 0L:6L,
  version = 1,
  verbose = TRUE,
  fovs = NULL
)

.load_merscope_folder_aggregate(
  dir_items,
  data_to_use,
  cores = NA,
  verbose = TRUE
)
```

## Arguments

- dir_items:

  list of full filepaths from
  [`.read_merscope_folder`](https://giottosuite.com/dev/reference/read_data_folder.md)

- data_to_use:

  which of either the 'subcellular' or 'aggregate' information to use
  for object creation

- polygon_format:

  format of the boundary files, either 'parquet' or 'hdf5' (v2 only)

- poly_z_indices:

  which z-indices to use for the polygons (Default 0:6 for v2, 1:7 for
  v1)

- version:

  integer. Version of logic to use (1 = Legacy/Original, 2 =
  New/Optimized)

- cores:

  how many cores or threads to use to read data if paths are provided

- verbose:

  be verbose when building Giotto object

## Value

list of loaded-in MERSCOPE data

## Functions

- `.load_merscope_folder_subcellular()`: Load items for 'subcellular'
  workflow

- `.load_merscope_folder_aggregate()`: Load items for 'aggregate'
  workflow
