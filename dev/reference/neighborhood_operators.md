# Neighbourhood operators of the BANKSY embedding

Building blocks of
[`neighborhoodPCAParam()`](https://giottosuite.com/dev/reference/neighborhoodPCAParam.md),
exported for backends that compute the embedding in windows
(GiottoDisk). `neighborhood_operators()` turns the directed edges of a
spatial network (from each cell to its neighbours) into sparse cells x
cells operators, row `j` for cell `j`:

- `w`: weights `exp(-d^2 / m^2)`, `m` the median distance of the cell's
  neighbours, normalized per cell, as Banksy's `kNN_median`

- `wc`, `ws`: `w * cos(phi)` and `w * sin(phi)`, `phi` the angle from
  the cell to the neighbour

- `a`: one over the cell's number of neighbours, the plain neighbour
  mean

`neighborhood_agf()` returns Banksy's azimuthal gradient (harmonic 1,
centred): per feature and cell, `|sum_i w_i exp(i phi_i) (x_i - mean)|`
over the cell's neighbours. Rows of `ops` may be a subset of cells as
long as their columns cover all neighbours.

## Usage

``` r
neighborhood_operators(from, to, locs)

neighborhood_agf(x, ops)
```

## Arguments

- from, to:

  integer cell indices (rows of `locs`) of the edges: from a cell to its
  neighbour; self edges are dropped

- locs:

  cells x 2 coordinates, with the cell IDs as row names

- x:

  features x cells values, columns in the order of the columns of the
  operators

- ops:

  operators from `neighborhood_operators()` (`a`, `wc`, `ws`)

## Value

`neighborhood_operators()`: a list of sparse matrices `w`, `wc`, `ws`,
`a`. `neighborhood_agf()`: a features x cells matrix (cells: rows of
`ops`).

## References

Singhal V, Chou N, Lee J, et al. BANKSY unifies cell typing and tissue
domain segmentation for scalable spatial omics data analysis. *Nature
Genetics* 56, 431-441 (2024).
[doi:10.1038/s41588-024-01664-3](https://doi.org/10.1038/s41588-024-01664-3)

## See also

[`spatial_smooth_operator()`](https://giotto-suite.github.io/GiottoClass/reference/spatial_smooth_operator.html)
for a symmetric smoothing operator

## Examples

``` r
xy <- matrix(runif(40), ncol = 2, dimnames = list(paste0("c", 1:20), NULL))
nn <- dbscan::kNN(xy, k = 4)
ops <- neighborhood_operators(rep(1:20, 4), as.vector(nn$id), xy)
x <- matrix(rpois(60, 3), 3, dimnames = list(NULL, rownames(xy)))
neighborhood_agf(x, ops)[, 1:3]
```
