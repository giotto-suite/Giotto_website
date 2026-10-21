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

  \`"subcellular"\` (default) loads transcripts, polygons and the cell
  by gene matrix. \`"aggregate"\` loads the cell by gene matrix, with
  cell centers from \`cell_metadata.csv\` as spatial locations.

- polygon_format:

  format of the cell boundaries, either \`"parquet"\` (default,
  \`cell_boundaries.parquet\`) or \`"hdf5"\` (per-FOV files in
  \`cell_boundaries/\`)

- poly_z_indices:

  which z-indices to use for the polygons. \`NULL\` (default) uses the
  lowest z-plane when all z-planes hold identical boundaries and stops
  otherwise.

- version:

  deprecated. Use \`polygon_format\`.

- cores:

  deprecated.

- verbose:

  be verbose (default \`NULL\`)

## Value

list of loaded-in MERSCOPE data

## Functions

- `.load_merscope_folder_subcellular()`: Load items for 'subcellular'
  workflow

- `.load_merscope_folder_aggregate()`: Load items for 'aggregate'
  workflow
