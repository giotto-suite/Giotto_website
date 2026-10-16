# Deconvolution params

Parameter objects for spatial cell type deconvolution. Pass one to
[`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
together with a signature matrix and a cluster vector, or use the
[`runDWLSDeconv()`](https://giottosuite.com/dev/reference/runDWLSDeconv.md)
wrapper, which builds the param for you.

## Usage

``` r
deconvParam(method = "DWLS", ...)
```

## Arguments

- method:

  character. Only `"DWLS"` for now.

- ...:

  method-specific parameters; see Details.

## Value

a deconvParam-inheriting object

## Details

DWLS:

- `logbase`:

  numeric. log base of the expression values (default 2).

- `n_cell`:

  numeric. expected number of cells per spot (default 50). A cell type
  is kept for a spot in the second round only when its first round
  proportion is at least `1 / n_cell`.

- `cutoff`:

  numeric. PAGE z-score a cell type must reach somewhere in a cluster to
  be a candidate for that cluster (default 2).

- `na_as_zero`:

  logical. spots that cannot be solved (no signal on the signature
  features) are `NA` by default; `TRUE` returns them as 0.

- `BPPARAM`:

  a `BiocParallelParam` for the per-spot solves. `NULL` (default) uses
  `getOption("giotto.bpparam")` when that is a parallel param, and runs
  serially otherwise.

- `chunk_size`:

  integer. spots per parallel task (default 256).

## See also

[analyze_param](https://giottosuite.com/dev/reference/analyze_param.md),
[`runDWLSDeconv()`](https://giottosuite.com/dev/reference/runDWLSDeconv.md)

Other spatial deconvolution:
[`deconv_dwls`](https://giottosuite.com/dev/reference/deconv_dwls.md),
[`makeSignMatrixDWLS()`](https://giottosuite.com/dev/reference/makeSignMatrixDWLS.md),
[`makeSignMatrixDWLSfromMatrix()`](https://giottosuite.com/dev/reference/makeSignMatrixDWLSfromMatrix.md),
[`runDWLSDeconv()`](https://giottosuite.com/dev/reference/runDWLSDeconv.md),
[`runSpatialDeconv()`](https://giottosuite.com/dev/reference/runSpatialDeconv.md)

## Examples

``` r
p <- deconvParam("DWLS", n_cell = 20)
p$n_cell
```
