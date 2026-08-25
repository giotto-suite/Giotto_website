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
importXenium(xenium_dir = NULL, qv_threshold = 20)
```

## Arguments

- xenium_dir:

  Xenium output directory

- qv_threshold:

  Minimum Phred-scaled quality score cutoff to be included as a
  subcellular transcript detection (default = 20)

## Value

\`XeniumReader\` object
