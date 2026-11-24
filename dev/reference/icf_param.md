# Interaction-changed feature params

Parameter objects for interaction-changed feature (ICF) analysis through
[`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md).
Use them through
[`findInteractionChangedFeats()`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)
with `method = "edgeicg"`, or pass one to
[`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
with a `giotto` object.

`"edgeicg"` (package edgeicg) tests, for every receiver cell type,
sender cell type and feature, whether the receiver's expression changes
with its exposure to the sender at three scales: touching cells
(`contact`), short-range neighbours (`paracrine`) and the regional
neighbourhood (`niche`). Transcripts leaked from touching neighbours are
modelled and removed per cell before testing; niche hits are calibrated
with a spatial (toroidal-shift) null and attributed to senders.

## Usage

``` r
icfParam(method = "edgeicg", ...)
```

## Arguments

- method:

  character. Only `"edgeicg"` for now.

- ...:

  method-specific parameters; see Details.

## Value

an icfParam-inheriting object

## Details

edgeicg:

- `expression_values`:

  raw counts to use (default `"raw"`). The model needs counts, not
  normalized values.

- `use_polygons`:

  logical. Build the spillover graph (touching cells) from the cell
  polygons of the spatial unit when they exist (default `TRUE`);
  otherwise k nearest neighbours.

- `block_genes`:

  integer. features per block; bounds memory (default 500).

- `workers`:

  integer. `mirai` daemons (default 0, sequential). Results are
  identical.

- `window_cells`:

  cells per window. Above this, cells are visited in spatially ordered
  windows and every statistic is summed over windows, so memory does not
  grow with the dataset. Default: one window for in-memory counts; for a
  GiottoDisk store, one window per worker (at most 50,000 cells), with
  the store baked once in window order and read in contiguous cell
  ranges.

- `backend`:

  `"auto"` (default: the Rust kernels of edgeicgrs when installed),
  `"rust"` or `"r"`.

- `calibrate`:

  logical. spatial calibration of the niche scale (default `TRUE`).

- `min_shift`:

  numeric. minimum calibration shift in microns (default 450).

- `report_q`:

  numeric. entries with q below this are returned in `ICFscores`
  (default 0.1); the full fit is kept in `$edgeicg`.

- `min_lfc`:

  numeric. entries must also change by at least this log2 fold change
  between receivers at the 10th and 90th percentile of their exposure
  (default 0.25; 0 = significance only). At whole-section scale
  significance alone also picks up small confounded associations
  (zonation, sub-states within a cell type).

- `spatial_covariates`:

  logical. adjust the niche screen for smooth spatial trends
  (`edgeicg::spatial_basis()`), which removes most large-scale zonation
  from niche hits; slower (default `FALSE`).

- `spatial_df`, `covariate_scope`:

  spline degrees of freedom per axis of the spatial basis (default 6)
  and where it enters: `"niche"` (default) or `"all"` tests.

- other:

  passed to `edgeicg::edgeicg()` (e.g. `min_cells`, `min_det`,
  `min_exposed`, `calib_cond`).

## See also

[`findInteractionChangedFeats()`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md),
[analyze_param](https://giottosuite.com/dev/reference/analyze_param.md)

## Examples

``` r
p <- icfParam("edgeicg", workers = 4)
p$workers
```
