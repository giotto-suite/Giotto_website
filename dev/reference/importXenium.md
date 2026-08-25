# Import a 10X Xenium Assay

Giotto import functionalities for Xenium datasets. This function creates
a \`XeniumReader\` instance that has convenient reader functions for
converting individual pieces of Xenium data into Giotto-compatible
representations.

These functions should have all param values provided as defaults, but
can be flexibly modified to do things such as look in alternative
directories or paths

## Usage

``` r
importXenium(xenium_dir = NULL, qv_threshold = 20, backend = NULL)
```

## Arguments

- xenium_dir:

  Xenium output directory

- qv_threshold:

  Minimum Phred-scaled quality score cutoff to be included as a
  subcellular transcript detection (default = 20)

- backend:

  (optional) a \`gsource\`-inheriting project backend (typically
  produced by \`GiottoDisk::sourceCreate()\`). When provided, creates
  the \`giotto\` object as a managed on-disk project.

## Value

\`XeniumReader\` object, or \`XeniumDiskReader\` when \`backend\` is set
