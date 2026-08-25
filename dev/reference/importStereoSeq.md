# Import a Stereo-seq assay

Giotto import functionalities for Stereo-seq datasets. This function
generates a \`StereoSeqReader\` instance with convenient reader
functions for loading individual pieces of Stereo-seq data into
Giotto-compatible representations when the param \`stereoseq_dir\` is
provided. A function that creates the full \`giotto\` object is also
available. These functions should have all param values provided as
defaults, but can be flexibly modified to look in alternative
directories or paths.

## Usage

``` r
importStereoSeq(
  stereoseq_dir = NULL,
  type = c("bin", "cell"),
  bin_size = "bin100",
  gene_column = c("geneName", "geneID"),
  negative_y = TRUE,
  gef_type = NULL
)

# S4 method for class 'StereoSeqReader,missing'
plot(x, y, ...)
```

## Arguments

- stereoseq_dir:

  filepath to the Stereo-seq \`outs\` directory.

- type:

  character. One of \`"bin"\` (square bin, default) or \`"cell"\` (cell
  bin / cellbin).

- bin_size:

  character. Bin size level to load when \`type = "bin"\`. One of
  \`"bin1"\`, \`"bin5"\`, \`"bin10"\`, \`"bin20"\`, \`"bin50"\`,
  \`"bin100"\`, \`"bin150"\`, \`"bin200"\`. Default is \`"bin100"\`.
  List available bins in your sample with
  \`rhdf5::h5ls("path/to/\*.tissue.gef")\`.

- gene_column:

  character. Which column to use as feature identifiers. One of
  \`"geneName"\` (default) or \`"geneID"\`.

- negative_y:

  logical. Map data to negative y spatial values (default \`TRUE\`).
  Origin is placed at the upper-left instead of lower-left.

- x:

  \`StereoSeqReader\`

- ...:

  additional params to pass

## Value

\`StereoSeqReader\` object

## Details

Loading functions are generated after \`stereoseq_dir\` is set.

## Examples

``` r
if (FALSE) { # \dontrun{
# Create a StereoSeqReader
reader <- importStereoSeq(
    stereoseq_dir = "path/to/outs",
    type = "bin",
    bin_size = "bin100"
)

# Load expression or spatial locations individually
expr   <- reader$load_expression()
sl     <- reader$load_spatlocs()
img    <- reader$load_image()

# Create a full giotto object
g <- reader$create_gobject()

# Change bin size and recreate
reader$bin_size <- "bin50"
g <- reader$create_gobject()
} # }
```
