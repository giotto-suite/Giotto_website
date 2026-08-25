# Import a Visium HD assay

Giotto import functionalities for Visium HD datasets. This function
generates a \`VisiumHDReader\` instance that has convenient reader
functions for converting individual pieces of Visium HD data into
Giotto-compatible representations when the param \`visiumhd_dir\` is
provided. A function that creates the full \`giotto\` object is also
available. These functions should have all param values provided as
defaults, but can be flexibly modified to do things such as look in
alternative directories or paths.

## Usage

``` r
importVisiumHD(
  visiumhd_dir = NULL,
  bin = 8,
  micron = FALSE,
  outdir = NULL,
  expression_source = "raw",
  feature_id_type = c("symbol", "ensembl"),
  tissue_only = FALSE,
  barcodes = NULL,
  array_subset_row = NULL,
  array_subset_col = NULL,
  pxl_subset_row = NULL,
  pxl_subset_col = NULL,
  filter = NULL,
  filter_coverage_cutoff = 0.5
)

# S4 method for class 'VisiumHDReader,missing'
plot(x, image = FALSE, ...)
```

## Arguments

- visiumhd_dir:

  Visium HD output directory containing tar outputs or their extracted
  \`square\_?um\` directories.

- bin:

  numeric. Bin level to load from. Currently one of 2, 8, or 16.

- micron:

  logical. Set \`TRUE\` to load in micron scale instead of fullres image
  mapping.

- outdir:

  (optional) directory to unpack bin output tar contents into. (Default
  is the same directory as the tarfile.)

- expression_source:

  character. Raw or filter expression data. Defaults to "raw"

- feature_id_type:

  character. One of \`"symbol"\` or \`"ensembl"\`. Determines which to
  use as the feature identifiers.

- tissue_only:

  logical. Whether to only load information tagged as \`in_tissue\` (in
  \`tissue_positions.parquet\`). This is ignored by transcript loading.

- barcodes:

  (optional) character. Specific pixel barcodes to keep.

- array_subset_row:

  (optional) numeric vector, length = 2. Min/max of array rows to keep

- array_subset_col:

  (optional) numeric vector, length = 2. Min/max of array cols to keep

- pxl_subset_row:

  (optional) numeric vector, length = 2. Min/max of fullres image mapped
  rows to keep. Note that values are inverted into the negatives.

- pxl_subset_col:

  (optional) numeric vector, length = 2. Min/max of fullres image mapped
  cols to keep.

- filter:

  (optional) a \`SpatVector\`, \`sf\`, or \`giottoPolygon\` to spatially
  filter the data by.

- filter_coverage_cutoff:

  numeric between 0 and 1. Minimal fraction of pixel coverage by
  \`filter\` in order to be selected.

- x:

  \`VisiumHDReader\`

- image:

  logical. Whether to plot the image

- ...:

  additional params to pass

## Value

\`VisiumHDReader\` object

## Details

Loading functions are generated after the \`visiumhd_dir\` is added.

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a `VisiumHDReader` object
reader <- importVisiumHD(bin = 16, tissue_only = TRUE)

# visualization
plot(reader)
plot(reader, image = TRUE)
reader$micron <- TRUE
plot(reader, image = TRUE)
reader$micron <- FALSE # reset

# Set the visiumhd_dir
reader$visiumhd_dir <- "path to visium HD dir"
readerHD$visiumhd_dir <- visiumhd_dir

# Load tissue positions or create cell metadata
tissue_pos <- readerHD$load_tissue_position()
metadata <- readerHD$load_cellmeta()

# Load matrix or create expression object
expression_obj <- readerHD$load_expression()

# Load transcript data (cell metadata, expression object, and transcripts
# per pixel)
my_transcripts <- readerHD$load_transcripts(
    array_subset_row = c(500, 1000),
    array_subset_col = c(500, 1000)
)

# Create a `giotto` object and add the loaded data
g <- reader$create_gobject()
} # }
```
