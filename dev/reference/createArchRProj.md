# Create an ArchR project and run LSI dimension reduction

Create an ArchR project and run LSI dimension reduction

## Usage

``` r
createArchRProj(
  fragmentsPath,
  genome = c("hg19", "hg38", "mm9", "mm10"),
  createArrowFiles_params = list(sampleNames = "sample1", minTSS = 0, minFrags = 0,
    maxFrags = 1e+07, minFragSize = 10, maxFragSize = 2000, offsetPlus = 0, offsetMinus =
    0, TileMatParams = list(tileSize = 5000)),
  ArchRProject_params = list(outputDirectory = getwd(), copyArrows = FALSE),
  addIterativeLSI_params = list(),
  threads = ArchR::getArchRThreads(),
  force = FALSE,
  verbose = TRUE
)
```

## Arguments

- fragmentsPath:

  A character vector containing the paths to the input files to use to
  generate the ArrowFiles. These files can be in one of the following
  formats: (i) scATAC tabix files, (ii) fragment files, or (iii) bam
  files.

- genome:

  A string indicating the default genome to be used for all ArchR
  functions. Currently supported values include "hg19","hg38","mm9", and
  "mm10". This value is stored as a global environment variable, not
  part of the ArchRProject. This can be overwritten on a per-function
  basis using the given function's geneAnnotationand genomeAnnotation
  parameter. For something other than one of the currently supported,
  see createGeneAnnnotation() and createGenomeAnnnotation()

- createArrowFiles_params:

  list of parameters passed to \`ArchR::createArrowFiles\`

- ArchRProject_params:

  list of parameters passed to \`ArchR::ArchRProject\`

- addIterativeLSI_params:

  list of parameters passed to \`ArchR::addIterativeLSI\`

- threads:

  number of threads to use. Default = \`ArchR::getArchRThreads()\`

- force:

  Default = FALSE

- verbose:

  Default = TRUE

## Value

An ArchR project with GeneScoreMatrix, TileMatrix, and TileMatrix-based
LSI
