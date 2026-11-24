# Neighborhood PCA parameters

Parameters for
[`reduceData()`](https://giotto-suite.github.io/GiottoClass/reference/reduceData.html)
that compute the BANKSY embedding of Singhal et al. (2024): each cell's
values are joined by the weighted mean of its `k_geom` nearest spatial
neighbours, the two blocks are scaled per feature, weighted by
\\\sqrt{1 - \lambda}\\ and \\\sqrt{\lambda}\\, and reduced by PCA.
Neighbour weights are \\\exp(-d^2 / m^2)\\, with \\m\\ the median
distance of the cell's `k_geom` neighbours, normalized to sum to one per
cell, as in the Banksy package.

With `compute_agf = TRUE` a third block adds BANKSY's azimuthal Gabor
filter (AGF): the magnitude of \\\sum_i w\_{ji} e^{i\phi\_{ji}} (x_i -
\bar{x}\_j)\\, the gradient of the neighbourhood around cell \\j\\
(\\\phi\\ the angle to neighbour \\i\\, \\\bar{x}\_j\\ the mean of its
neighbours), and \\\lambda\\ is split over the blocks as \\\sqrt{1 -
\lambda}\\, \\\sqrt{2\lambda/3}\\ and \\\sqrt{\lambda/3}\\, as in
Banksy.

This is a reimplementation of BANKSY's embedding. **If you use it,
please cite the original paper** (see References).
[`GiottoConnect::runBanksy()`](https://giotto-suite.github.io/GiottoConnect/reference/runBanksy.html)
runs the original Banksy package.

## Usage

``` r
neighborhoodPCAParam(
  lambda = 0.2,
  k_geom = 15L,
  npcs = 20L,
  compute_agf = FALSE,
  absolute = FALSE,
  seed = 1234L
)

# S4 method for class 'allMatrix,neighborhoodPCAParam'
reduceData(x, param, ..., spatial_locs, network, agf_network = network)
```

## Arguments

- lambda:

  numeric in `[0, 1]`, the weight of the neighbourhood. About 0.2
  refines cell types with their surroundings; about 0.8 finds spatial
  domains.

- k_geom:

  integer, number of neighbours of the kNN spatial network
  [`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md)
  creates when the object has none; with `compute_agf = TRUE` one value,
  or two (mean and gradient)

- npcs:

  integer, number of principal components

- compute_agf:

  logical, add the AGF (gradient) block

- absolute:

  logical. Take the absolute value of the neighbour means, as Banksy 1.6
  does. This makes no difference for non-negative values such as
  expression, but discards the sign of signed inputs such as an
  embedding, so it is `FALSE` by default.

- seed:

  integer, seed of the PCA

- x:

  features x cells values (\`matrix\` or \`Matrix\`)

- param:

  a \`neighborhoodPCAParam\`

- ...:

  unused

- spatial_locs:

  cells x 2 (or 3) coordinates, with the cell IDs as row names

- network:

  spatial network of the neighbours: an \`igraph\` or a \`data.frame\`
  with \`from\` and \`to\` cell IDs. A directed network (kNN) gives each
  cell the neighbours it points to, an undirected one (Delaunay) both
  ends of each edge; a \`data.frame\` is read as directed.

- agf_network:

  spatial network of the gradient block (default \`network\`)

## Value

A `neighborhoodPCAParam` object.

## Details

\`reduceData(x, param, spatial_locs = , network = )\` returns the list
of \[pcaParam()\]'s \`reduceData()\` methods (\`u\`: cells x \`npcs\`
coordinates, \`d\`, \`v\`: loadings of the joint features, \`sdev\`,
\`eigenvalues\`).

## References

Singhal V, Chou N, Lee J, et al. BANKSY unifies cell typing and tissue
domain segmentation for scalable spatial omics data analysis. *Nature
Genetics* 56, 431–441 (2024).
[doi:10.1038/s41588-024-01664-3](https://doi.org/10.1038/s41588-024-01664-3)

## See also

[`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md),
[`GiottoConnect::runBanksy()`](https://giotto-suite.github.io/GiottoConnect/reference/runBanksy.html)

## Examples

``` r
p <- neighborhoodPCAParam(lambda = 0.8, k_geom = 15)
p$lambda
```
