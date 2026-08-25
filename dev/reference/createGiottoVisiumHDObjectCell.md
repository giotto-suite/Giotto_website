# Create 10x VisiumHD Giotto Object from Segmented Outputs

Convenience function to create a Giotto object from a VisiumHD
\`segmented_outputs\` folder (Space Ranger v4+). Point
\`segmented_outputs_dir\` directly at the \`segmented_outputs\`
directory. For lower-level loading of individual pieces of data, see
\[importVisiumHD()\].

Transcript loading (2 µm bin data) requires access to the
\`binned_outputs\` directory. When \`load_transcripts = TRUE\` the
function first tries to auto-detect \`binned_outputs\` as a sibling
directory next to \`segmented_outputs\`. If it cannot be found, an error
is thrown and the user should supply \`binned_outputs_dir\` explicitly.

## Usage

``` r
createGiottoVisiumHDObjectCell(
  segmented_outputs_dir,
  load_expression = TRUE,
  load_polygons = c("cell", "nucleus"),
  graphclust_annotated = FALSE,
  load_image = TRUE,
  load_transcripts = FALSE,
  binned_outputs_dir = NULL,
  micron = FALSE,
  barcodes = NULL,
  expression_source = "raw",
  feature_id_type = c("symbol", "ensembl"),
  expression_remove_zero_rows = TRUE,
  expression_split_by_type = TRUE,
  image_type = "hires",
  scalefactors_path = NULL,
  expression_path = NULL,
  image_path = NULL,
  geojson_path = NULL,
  instructions = NULL,
  verbose = NULL
)
```

## Arguments

- segmented_outputs_dir:

  filepath to the VisiumHD \`segmented_outputs\` directory.

- load_expression:

  logical. Whether to load expression matrix.

- load_polygons:

  character. Which polygon types to load. One or both of \`"cell"\` and
  \`"nucleus"\`. Set to \`NULL\` or \`character(0)\` to skip.

- graphclust_annotated:

  logical. Whether to load graphclust-annotated polygon variants.

- load_image:

  logical. Whether to load the paired image.

- load_transcripts:

  logical. Whether to load 2 µm bin data as transcripts. Very memory
  expensive. Requires access to the \`binned_outputs\` directory
  (auto-detected or supplied via \`binned_outputs_dir\`).

- binned_outputs_dir:

  (optional) filepath to the VisiumHD \`binned_outputs\` directory. Only
  needed when \`load_transcripts = TRUE\` and auto-detection of the
  sibling \`binned_outputs\` folder fails.

- micron:

  logical. Set \`TRUE\` to load in micron scale.

- barcodes:

  character. Specific cell barcodes to keep.

- expression_source:

  character. One of \`"raw"\` or \`"filtered"\`.

- feature_id_type:

  character. One of \`"symbol"\` or \`"ensembl"\`.

- expression_remove_zero_rows:

  logical (default \`TRUE\`). Whether to remove features with no
  detections.

- expression_split_by_type:

  logical (default \`TRUE\`). Whether to split expression by feature
  type.

- image_type:

  character. One of \`"hires"\` (default) or \`"lowres"\`.

- scalefactors_path:

  (optional) filepath to \`scalefactors_json.json\`.

- expression_path:

  (optional) filepath to .h5 or matrix market directory.

- image_path:

  (optional) filepath to image to use.

- geojson_path:

  (optional) filepath or directory for polygon \`.geojson\` files.

- instructions:

  giotto instructions to apply.

- verbose:

  verbosity

## Value

giotto object

## See also

\[importVisiumHD()\] \[createGiottoVisiumHDObjectBin()\]

## Examples

``` r
if (FALSE) {
seg_dir <- "path/to/visiumhd/segmented_outputs"
g <- createGiottoVisiumHDObjectCell(seg_dir)

# with transcript loading (auto-detects ../binned_outputs/)
g <- createGiottoVisiumHDObjectCell(seg_dir, load_transcripts = TRUE)

# with explicit binned_outputs path
g <- createGiottoVisiumHDObjectCell(seg_dir,
    load_transcripts = TRUE,
    binned_outputs_dir = "path/to/visiumhd/binned_outputs"
)
}
```
