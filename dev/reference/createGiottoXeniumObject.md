# Create 10x Xenium Giotto Object

Create a Giotto object from a Xenium experiment output folder. Only the
`xenium_dir`, `load_images`, and `load_aligned_images` params need to be
supplied when defaults are sufficient. All other params have defaults
set and are there in case of non-standard directory layouts or
alternative preference in file format to load from.  
When possible, `.parquet` files are loaded. This requires the additional
installation of arrow with zstd support. See details. `h5` is also used
by default if the 10x provided expression matrix is loaded.  
The 10X provided aggregated expression matrix and cell metdata are not
loaded by default since the results may be slightly different from those
that Giotto spatially aggregates.

## Usage

``` r
createGiottoXeniumObject(
  xenium_dir,
  transcript_path = NULL,
  bounds_path = list(cell = "cell", nucleus = "nucleus"),
  gene_panel_json_path = NULL,
  expression_path = NULL,
  cell_metadata_path = NULL,
  feat_type = c("rna", "NegControlProbe", "UnassignedCodeword", "NegControlCodeword",
    "GenomicControl"),
  split_keyword = list("NegControlProbe", "UnassignedCodeword", "NegControlCodeword",
    "GenomicControl"),
  qv_threshold = 20,
  load_images = "focus",
  load_aligned_images = NULL,
  load_transcripts = TRUE,
  load_expression = TRUE,
  load_cellmeta = FALSE,
  instructions = NULL,
  verbose = NULL
)
```

## Arguments

- xenium_dir:

  Full path to the exported xenium directory

- transcript_path:

  Optional. Filepath to desired transcripts file to load. Either the
  `.parquet` or `.csv` files can be used.

- bounds_path:

  Optional. Named list of filepaths to desired Xenium bounds/polygon
  files to load. Either the `.parquet` or `.csv` files can be used. The
  default is to load the `.parquets` of both cell and nucleus.

- gene_panel_json_path:

  Optional. Filepath to panel json. This json contains feature metadata
  information and ENSG names.

- expression_path:

  Optional. Filepath to cell feature matrix. Accepts either the `.h5` or
  the unzipped directory containing `.mtx` files.

- cell_metadata_path:

  Optional. Filepath to `cells.csv.gz` or `cells.parquet` which contain
  cell metadata information.

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

- qv_threshold:

  Minimum Phred-scaled quality score cutoff to be included as a
  subcellular transcript detection (default = 20)

- load_images:

  Named list of filepaths to `.tif` images, usually the ones in the
  `morphology_focus` directory. These `ome.tif` images are not
  compatible and must be converted to `tif` using
  `[GiottoClass::to_simple_tif()]`.

- load_aligned_images:

  Named list of filepaths. The list names are used as the image names
  when loaded. Two filepaths are expected per entry. The first one
  should be to the `.tif` image. The second path is to the `.csv`
  alignment matrix file. `ome.tif` images will work, but they are
  currently slower in our imaging pipeline.

- load_expression:

  logical. Default = FALSE. Whether to load in 10X provided expression
  matrix.

- load_cellmeta:

  logical. Default = FALSE. Whether to load in 10X provided cell
  metadata information

- instructions:

  list of instructions or output result from
  [`createGiottoInstructions()`](https://giotto-suite.github.io/GiottoClass/reference/giotto_instructions.html)

- verbose:

  logical or NULL. NULL uses the `giotto.verbose` option setting and
  defaults to TRUE.

## Value

`giotto` object

## Details

\[**arrow zstd support**\] Xenium parquets have zstd compression. arrow
is used to access parquets, however it may not install on all systems
with zstd by default. You can check whether zstd support is installed by
running: `arrow::arrow_info()$capabilities[["zstd"]]`. If `FALSE`, it
needs to be reinstalled with the following:


     Sys.setenv(ARROW_WITH_ZSTD = "ON")
     install.packages("arrow", repos = c("https://apache.r-universe.dev"))

\[**QC feature types**\] Xenium provides info on feature detections that
include more than only the Gene Expression specific probes. Additional
probes for QC are included: *blank codeword*, *negative control
codeword*, and *negative control probe*. These additional QC probes each
occupy and are treated as their own feature types so that they can
largely remain independent of the gene expression information.

\[**feat_type and split_keyword**\] Additional QC probe information is
in the subcellular feature detections information and must be separated
from the gene expression information during processing. The QC probes
have prefixes that allow them to be selected from the rest of the
feature IDs. Giotto uses `feat_type` and `split_keyword` params to
select these QC probes out as separate feature types. See examples in
`[GiottoClass::createGiottoPoints]` for how this works.

The Gene expression subset labeled as `rna` is accepted as the subset of
feat_IDs that do not get matched to any of the `split_keywords`.
