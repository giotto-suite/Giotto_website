# Create Vizgen MERSCOPE Giotto Object

Given the path to a MERSCOPE region directory, creates a Giotto object
from the vendor outputs: transcripts (\`detected_transcripts.parquet\`
or \`.csv\`), cell boundaries (\`cell_boundaries.parquet\`, or the
per-FOV HDF5 files in \`cell_boundaries/\`), the cell by gene matrix
(\`cell_by_gene.csv\`) and cell metadata (\`cell_metadata.csv\`). Calls
\[importMerscope()\] and the reader's \`create_gobject()\`.

No overlap between transcripts and polygons is calculated. Use
\[calculateOverlap()\] and \[overlapToMatrix()\] on the created object
to aggregate transcripts by polygon.

The y coordinates of transcripts, polygons and cell centers are negated
(\`y\` becomes \`-y\`).

## Usage

``` r
createGiottoMerscopeObject(
  merscope_dir,
  transcript_path = NULL,
  bounds_path = NULL,
  expression_path = NULL,
  cell_metadata_path = NULL,
  data_to_use = c("subcellular", "aggregate"),
  FOVs = NULL,
  polygon_format = c("parquet", "hdf5"),
  poly_z_indices = NULL,
  spat_unit = "cell",
  split_keyword = c("Blank"),
  score_threshold = NULL,
  load_transcripts = TRUE,
  load_expression = TRUE,
  load_cellmeta = FALSE,
  load_images = NULL,
  backend = NULL,
  instructions = NULL,
  verbose = NULL,
  version = deprecated(),
  flip_axis = deprecated(),
  calculate_overlap = deprecated(),
  overlap_to_matrix = deprecated(),
  aggregate_stack = deprecated(),
  aggregate_stack_param = deprecated(),
  cores = deprecated()
)

.createGiottoMerscopeObject_aggregate(data_list, cores = NA, verbose = TRUE)
```

## Arguments

- merscope_dir:

  full path to the MERSCOPE region directory

- transcript_path:

  (optional) path to the transcripts file. \`NULL\` (default) uses
  \`detected_transcripts.parquet\` or \`.csv\` in \`merscope_dir\`.

- bounds_path:

  (optional) path to the cell boundaries. \`NULL\` (default) uses
  \`cell_boundaries.parquet\`, or the \`cell_boundaries/\` directory
  when \`polygon_format = "hdf5"\`.

- expression_path:

  (optional) path to the cell by gene matrix. \`NULL\` (default) uses
  \`cell_by_gene.csv\` in \`merscope_dir\`.

- cell_metadata_path:

  (optional) path to the cell metadata. \`NULL\` (default) uses
  \`cell_metadata.csv\` in \`merscope_dir\`.

- data_to_use:

  \`"subcellular"\` (default) loads transcripts, polygons and the cell
  by gene matrix. \`"aggregate"\` loads the cell by gene matrix, with
  cell centers from \`cell_metadata.csv\` as spatial locations.

- FOVs:

  which FOVs to load. \`NULL\` (default) loads all FOVs.

- polygon_format:

  format of the cell boundaries, either \`"parquet"\` (default,
  \`cell_boundaries.parquet\`) or \`"hdf5"\` (per-FOV files in
  \`cell_boundaries/\`)

- poly_z_indices:

  which z-indices to use for the polygons. \`NULL\` (default) uses the
  lowest z-plane when all z-planes hold identical boundaries and stops
  otherwise.

- spat_unit:

  character. Name of the spatial unit for the polygons, expression, cell
  metadata and spatial locations (default \`"cell"\`)

- split_keyword:

  character vector of keywords to separate feature detections (default
  \`"Blank"\`). Detections matching \`"Blank"\` are loaded as the
  \`"neg_probe"\` feature type; other keywords are used as the feature
  type name.

- score_threshold:

  numeric or \`NULL\` (default). Minimum \`transcript_score\` for a
  transcript detection to be loaded. \`NULL\` loads all transcripts.

- load_transcripts:

  logical. Whether to load the transcripts (default \`TRUE\`)

- load_expression:

  logical. Whether to load the cell by gene matrix (default \`TRUE\`)

- load_cellmeta:

  logical. Whether to load the cell metadata (default \`FALSE\`)

- load_images:

  (optional) images to load. Character vector or list of mosaic names
  (e.g. \`"DAPI_z3"\` for \`images/mosaic_DAPI_z3.tif\`) or image file
  paths. Names of the list are used as image names. Images are placed
  with \`images/micron_to_mosaic_pixel_transform.csv\`. \`NULL\`
  (default) loads no images.

- backend:

  (optional) a \`gsource\`-inheriting project backend (typically
  produced by \`GiottoDisk::sourceCreate()\`). When provided, creates
  the \`giotto\` object as a managed on-disk project (See GiottoDisk).

- instructions:

  list of instructions or output result from
  \[createGiottoInstructions()\]

- verbose:

  be verbose (default \`NULL\`)

- version:

  deprecated. Use \`polygon_format\`.

- flip_axis:

  deprecated. Use \[flip()\] on the created object.

- calculate_overlap:

  deprecated. Use \[calculateOverlap()\] on the created object.

- overlap_to_matrix:

  deprecated. Use \[overlapToMatrix()\] on the created object.

- aggregate_stack:

  deprecated.

- aggregate_stack_param:

  deprecated.

- cores:

  deprecated.

- data_list:

  list of loaded data from
  [`load_merscope_folder`](https://giottosuite.com/dev/reference/load_merscope_folder.md)

## Value

a giotto object

## Functions

- `.createGiottoMerscopeObject_aggregate()`: Create giotto object with
  'aggregate' workflow

## See also

\[importMerscope()\]
