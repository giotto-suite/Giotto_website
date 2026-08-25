# Create a Giotto object from an ArchR project

Create a Giotto object from an ArchR project

## Usage

``` r
createGiottoObjectfromArchR(
  archRproj,
  expression = NULL,
  expression_feat = "atac",
  spatial_locs = NULL,
  sampleNames = "sample1",
  ...
)
```

## Arguments

- archRproj:

  ArchR project

- expression:

  expression information

- expression_feat:

  Giotto object available features (e.g. atac, rna, ...)

- spatial_locs:

  data.table or data.frame with coordinates for cell centroids

- sampleNames:

  A character vector containing the ArchR project sample name

- ...:

  additional arguments passed to \`createGiottoObject\`

## Value

A Giotto object with at least an atac or epigenetic modality
