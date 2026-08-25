# Create Nanostring CosMx Giotto Object

Given the path to a CosMx experiment directory, creates a Giotto object.
For lower level control over loading, please see
[`importCosMx()`](https://giottosuite.com/dev/reference/importCosMx.md)

## Usage

``` r
createGiottoCosMxObject(
  cosmx_dir,
  version = "default",
  FOVs = NULL,
  slide = 1,
  feat_type = c("rna", "negprobes"),
  split_keyword = list("NegPrb"),
  load_images = list(composite = "composite", overlay = "overlay"),
  load_expression = FALSE,
  load_cellmeta = TRUE,
  load_transcripts = TRUE,
  poly_pref = "mask",
  image_negative_y = NULL,
  fov_shifts_path = NULL,
  transcript_path = NULL,
  cell_labels_dir = NULL,
  expression_path = NULL,
  metadata_path = NULL,
  cores = determine_cores(),
  verbose = NULL,
  instructions = NULL,
  remove_unvalid_polygons = deprecated(),
  data_to_use = deprecated(),
  remove_background_polygon = deprecated(),
  background_algo = deprecated(),
  ...
)
```

## Arguments

- cosmx_dir:

  full path to the exported cosmx directory

- version:

  character. Version of CosMx output. Current selections are either
  "default", "v6", and "legacy" (for the NSCLC dataset).

- FOVs:

  field of views to load.

- slide:

  numeric. Slide number. Defaults to 1. This must be correct so that
  cell_IDs will match across polygons and (if loaded) expression matrix.

- feat_type:

  character. feature type. Provide more than one value if using the
  `split_keyword` param. For each set of keywords to split by, an
  additional feat_type should be provided in the same order. Affects how
  the transcripts information is loaded. Helpful for separating out the
  QC probes. See details.

- split_keyword:

  list of character vectors of keywords to split the transcripts based
  on their feat_ID. Keywords will be
  [`grepl()`](https://rdrr.io/r/base/grep.html) matched against the
  feature IDs information. See details.

- load_images:

  named list of filepaths to directories. Loads the composite and
  overlay images by default.

- load_expression:

  logical. (Default = FALSE) whether to load provided expression matrix

- load_cellmeta:

  logical. (Default = TRUE) whether to load provided cell metadata

- load_transcripts:

  logical. (Default = TRUE) whether to load provided transcript
  detections

- poly_pref:

  character. "mask" or "csv". Determines whether to load in the polygons
  from the mask images (default) or the csv polygons file.

- image_negative_y:

  Optional logical. Whether images are assumed to map to positive or
  negative y values before fov shifts are applied. Affects images (and
  polygons generated from masks). This overrides any settings from
  selecting `version`.

- fov_shifts_path:

  Optional. Filepath to fov_positions_file

- transcript_path:

  Optional. Filepath to desired transcripts file to load.

- cell_labels_dir:

  Optional. Path to directory containing CellLabels images to load as
  polygons.

- expression_path:

  Optional. Filepath to cell feature matrix to load.

- metadata_path:

  Optional. Filepath to metadata file to load.

- cores:

  nthreads to use when loading in cell metadata and transcripts

- verbose:

  be verbose when building Giotto object

- instructions:

  list of instructions or output result from
  [`createGiottoInstructions`](https://giotto-suite.github.io/GiottoClass/reference/giotto_instructions.html)

- remove_unvalid_polygons:

  deprecated. Now always done

- data_to_use:

  deprecated. Not used

- remove_background_polygon:

  deprecated. Now always done

- background_algo:

  deprecated. Not used

- ...:

  Arguments passed on to
  [`importCosMx`](https://giottosuite.com/dev/reference/importCosMx.md)

  `micron`

  :   logical. Whether to scale spatial information as micron instead of
      the default pixels

  `px2um`

  :   numeric. Scalefactor from pixels to micron. Defaults to 0.12028
      based on \`CosMx-ReadMe.html\` info. May be different depending on
      dataset.

## Value

a giotto object

## Details

\[**Expected Directory**\] This function generates a giotto object when
given a link to a cosmx output directory. It expects the following items
within the directory where the **bolded** portions are what this
function matches against:

- **CellComposite** (folder of images)

- **CellLabels** (folder of images)

- **CellOverlay** (folder of images)

- **CompartmentLabels** (folder of images)

- experimentname\_**exprMat_file**.csv (file)

- experimentname\_**fov_positions_file**.csv (file)

- experimentname\_**metadata_file**.csv (file)

- experimentname\_**tx_file**.csv (file)

- experimentname-**polygons**.csv (file)

The subdirectories should contain only the image files in order to be
loaded correctly.

\[**feat_type and split_keyword**\] Additional QC probe information is
in the subcellular feature detections information and must be separated
from the gene expression information during processing. The QC probes
have prefixes that allow them to be selected from the rest of the
feature IDs. Giotto uses `feat_type` and `split_keyword` params to
select these QC probes out as separate feature types. See examples in
`[GiottoClass::createGiottoPoints]` for how this works.

The Gene expression subset labeled as `rna` is accepted as the subset of
feat_IDs that do not get matched to any of the `split_keywords`.

\[**Images**\] Images in the expected CellComposite and CellOverlay
folders will be loaded as giotto largeImage objects by default.

\[**Polygons**\] Some outputs provide both the mask images and the
`polygons.csv`. Giotto uses the mask images by default to convert to
polygons info. However, if only the `polygons.csv` file is present or
`poly_pref = csv` is set, then the csv file will be used instead. One
thing to watch out for when loading from the `csv` is that in some
datasets, the polygons preferably should not overlap each other. Giotto
is not fully compatible with overlapping annotations. It also opens up
the possibility of double counting transcripts. Polygon overlaps do not
appear to be an issue in the most recent outputs.

\[**Spatial Alignment Issues**\] Different versions of the CosMx output
have changed how images (and polygons generated from masks) should be
aligned relative to the vector information (transcript detections). The
`version` param affects how the images are mapped by default.
`image_negative_y` is a toggle that overrides the image mapping style
when an appropriate `version` is difficult to determine.
[`showGiottoImageNames`](https://giotto-suite.github.io/GiottoClass/reference/showGiottoImageNames.html)
can be used to see the available images.

## Examples

``` r
if (FALSE) { # \dontrun{
f <- "file path to cosmx flatfile output directory"
createGiottoCosMxObject(f)

# load older CosMx format
createGiottoCosMxObject(f, version = "legacy")

# force images and mask image polygons to shift up one image height
createGiottoCosMxObject(f, image_negative_y = FALSE)

# load only aggregated data
createGiottoCosMxObject(f,
    load_cellmeta = TRUE,
    load_expression = TRUE,
    load_transcripts = FALSE
    # data filepaths not needed unless they are not in expected locations
)
} # }
```
