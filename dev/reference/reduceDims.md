# Run dimension reduction method

Wrapper function for Giotto dimension reduction methods for easier
coding.

## Usage

``` r
reduceDims(
  gobject,
  method = c("pca", "nmf", "umap", "tsne"),
  projection = FALSE,
  toplevel = 1L,
  ...
)
```

## Arguments

- gobject:

  giotto object

- method:

  character. Dimension reduction method to use

- projection:

  logical. Whether to run in a projection manner (faster, but is an
  approximation)

- toplevel:

  relative stackframe the call was made at. do not use.

- ...:

  additional params to pass to specific functions

## Value

\`giotto\` object with attached dimension reduction

## Examples

``` r
g <- GiottoData::loadGiottoMini("vis")
x <- reduceDims(g, "tsne", spat_unit = "cell")
x <- reduceDims(x, "umap", projection = TRUE)
x <- reduceDims(x, method = "nmf")
```
