# HMRF clustering parameters

Parameters for
[`clusterData()`](https://giottosuite.com/dev/reference/clusterData.md)
that fit the hidden Markov random field (HMRF) model of Zhu et al.
(2018), as in the smfishHmrf package: each cell's z-scored expression of
spatial genes follows a multivariate Gaussian per domain, and a Potts
prior of strength `beta` favours domains shared with spatial neighbours.
Fitted by EM with iterated conditional modes over the colour classes of
the spatial network, from a k-means start.

The model is fitted by the spatialHMRF package, a reimplementation of
smfishHmrf. **If you use it, please cite the original paper** (see
References).

## Usage

``` r
hmrfParam(
  k = 10L,
  beta = 2,
  zscore = c("cell", "feature", "none"),
  nstart = 200L,
  seed = 100L,
  subsample = 20000L,
  maxit = 50L,
  err = 1e-07,
  label_tol = 1e-04,
  n_icm = 10L,
  damp_tolerance = 1e-05,
  damp_factor = 1.05
)

# S4 method for class 'allMatrix,hmrfParam'
clusterData(x, param, ..., network, blocks = NULL, init = NULL)
```

## Arguments

- k:

  integer, number of domains

- beta:

  numeric, strength of the spatial prior (0: no prior)

- zscore:

  `"cell"` (default, as smfishHmrf in Giotto): z-score each cell across
  the features after the input values; `"feature"`: z-score each feature
  across the cells, for a few features on different scales such as
  module scores (needs spatialHMRF \>= 0.1.1); `"none"`: use the values
  as given

- nstart:

  integer, k-means starts (smfishHmrf: 1000)

- seed:

  integer, seed of the k-means start

- subsample:

  integer: with more cells, the k-means restarts run on this many random
  cells and one k-means on all cells refines the best centres; `Inf`
  runs them on all cells, as smfishHmrf

- maxit:

  integer, maximum EM iterations

- err:

  numeric, relative change of means and covariances at which EM stops

- label_tol:

  numeric, share of cells changing domain at which EM stops; 0 stops on
  `err` or `maxit` only, as smfishHmrf

- n_icm:

  integer, ICM sweeps per EM iteration

- damp_tolerance, damp_factor:

  a domain's covariance whose determinant is below `damp_tolerance` gets
  the smallest diagonal term (searched in steps of `damp_factor` from
  1e-4) that brings it above, as in smfishHmrf

- x:

  cells x features values (\`matrix\` or \`Matrix\`), cell IDs as row
  names (the orientation of the other \`clusterData()\` methods)

- param:

  an \`hmrfParam\`

- ...:

  unused

- network:

  spatial network: a \`data.frame\` with columns \`from\` and \`to\`
  (cell IDs), each pair listed once

- blocks:

  optional list of integer vectors (positions in \`rownames(x)\`) that
  partition the cells into independent sets of the network; a DSatur
  colouring of the network when \`NULL\`

- init:

  optional list with \`mu\` (features x k), \`sigma\` (features x
  features x k) and \`damp\` (length k), e.g. to reuse one start for
  several \`beta\`

## Value

An `hmrfParam` object.

## Details

The computation is done by the spatialHMRF package
(\`spatialHMRF::hmrf()\`), which is suggested rather than imported:
install it with \`remotes::install_github("drieslab/spatialHMRF")\`.
\`clusterData(x, param, network = )\` returns a \`data.table\` with
\`cell_ID\` and \`cluster\` (integer). Its attributes: \`prob\` (cells x
k posterior probabilities), \`mu\`, \`sigma\`, \`likelihood\`,
\`iterations\`, \`init\` and \`blocks\`.

## References

Zhu Q, Shah S, Dries R, Cai L, Yuan GC. Identification of spatially
associated subpopulations by combining scRNAseq and sequential
fluorescence in situ hybridization data. *Nature Biotechnology* 36,
1183–1190 (2018).
[doi:10.1038/nbt.4260](https://doi.org/10.1038/nbt.4260)

## See also

[`runHMRF()`](https://giottosuite.com/dev/reference/runHMRF.md)

## Examples

``` r
p <- hmrfParam(k = 5, beta = 2)
```
