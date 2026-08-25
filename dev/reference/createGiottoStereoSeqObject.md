# Create Stereo-seq Giotto Object

Create Stereo-seq Giotto Object

## Usage

``` r
createGiottoStereoSeqObject(
  stereoseq_dir,
  type = "squarebin",
  bin_size = "bin100",
  gene_column = "geneName",
  negative_y = TRUE,
  shift_polygon_y = 0,
  verbose = TRUE,
  h5_file = NULL,
  instructions = NULL
)
```

## Arguments

- stereoseq_dir:

  filepath to the exported Stereo-seq directory.

- type:

  character. Use "squarebin" to read expression at different bin levels
  (default), "cellbin" to read expression at cell resolution, or
  "subcellular" to read individual transcripts and cell boundaries.

- bin_size:

  bin size. Choose a value from "bin1", "bin5", "bin10", "bin20",
  "bin50", "bin100", "bin150", or "bin200". List the available bins in
  your sample using rhdf5::h5ls("path/to/\*.tissue.gef"). Only needed
  when using type = "squarebin".

- gene_column:

  (optional) character. Which column contains the gene names within the
  geneExp information. Choose from "geneName" (default), or "geneID"

- negative_y:

  logical. Map data to negative y spatial values during automatic
  alignment (Default = TRUE). Meaning that origin is in upper left
  instead of lower left. from
  [`createGiottoInstructions`](https://giotto-suite.github.io/GiottoClass/reference/giotto_instructions.html)

- verbose:

  logical. Be verbose.

- h5_file:

  (optional) name to create an on-disk HDF5 file.

- instructions:

  list of instructions or output result

## Value

Giotto Stereo-seq object

## Details

This function is deprecated. Use \[createGiottoStereoSeqObjectBin()\]
for square bin data or \[createGiottoStereoSeqObjectCell()\] for cell
bin data. The \`"subcellular"\` type is still only available through
this function.

## See also

\[importStereoSeq()\] \[createGiottoStereoSeqObjectBin()\]
\[createGiottoStereoSeqObjectCell()\]
