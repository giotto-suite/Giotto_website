# Changelog

## Giotto 4.2.4 (in development)

### Bug fixes

- [`createGiottoXeniumObject()`](https://giottosuite.com/dev/reference/createGiottoXeniumObject.md)
  no longer errors on Xenium-format directories that ship no panel json;
  feature metadata is generated from the expression matrix when the
  panel is absent.

### Breaking changes

- [`findScranMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findScranMarkers_one_vs_all.md)
  returns `cluster` as **character**. All
  [`findMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findMarkers_one_vs_all.md)
  methods now agree on the type, so their results can be joined or
  stacked on `cluster` regardless of `method`; previously scran
  disagreed with gini. Code comparing against a numeric literal needs
  `"3"` rather than `3`. Note that `method = "mast"` labels the
  comparison (`"3_vs_others"`) rather than the bare cluster id, so joins
  across mast and the others still need a translation step.
- `calculateHVF(method = "var_p_resid")` now computes analytic Pearson
  residuals itself, from **raw counts**, instead of taking the plain
  variance of whatever matrix it was handed. **Selected features will
  differ from previous releases.** Previously the residual criterion
  required running `normalizeGiotto(norm_methods = "pearson_resid")`
  first *and* passing `expression_values = "scaled"` (the slot that
  normalization writes to, not the `"normalized"` default) — a three-way
  agreement nothing verified, and which silently returned the variance
  of library-normalized values whenever it was not met.
  `expression_values` is now ignored for this method, with a warning if
  it was set explicitly.
  `normalizeGiotto(norm_methods = "pearson_resid")` is unaffected and
  remains available for producing residuals as a stored matrix.
- `analyzeData(x, varParam)` correspondingly returns the residual
  variance, and gained a `mean_expr` column. It gains a `theta`
  parameter (default `100`, following Lause/Kobak and matching
  [`normalizeGiotto()`](https://giottosuite.com/dev/reference/normalizeGiotto.md));
  [`calculateHVF()`](https://giottosuite.com/dev/reference/calculateHVF.md)
  exposes the same argument. `IterableMatrix` (BPCells) input now errors
  rather than silently returning a different statistic.
- [`calculateHVF()`](https://giottosuite.com/dev/reference/calculateHVF.md)
  gains `n_top_feats` (default `2000`), a top-N cut that applies to
  **all three** methods, combined with each method’s own threshold so
  the more restrictive one decides. `var_number` is deprecated in favour
  of it — the old name implied variance and the cut is now
  method-agnostic. Each method ranks on its own score: residual
  variance, within-bin COV z-score, or COV above the LOESS fit. For
  `cov_groups` the z-score is standardised within expression bins, so a
  global ranking stays balanced across expression levels (a top-2000 cut
  on a Stereo-seq transcriptome drew 9.6-12.4% from each of 19 of 20
  bins; the highest-expression bin is under-represented because COV is
  compressed there by construction). In practice only `cov_loess`
  changes at the default — 6,043 features selected before, 2,000 now —
  since `cov_groups`’s `zscore_threshold` is already stricter than the
  count.
- `calculateHVF(method = "var_p_resid")` selection defaults change to
  `n_top_feats = 2000` (was no count) and `var_threshold = 1` (was
  `1.5`), and the two are now applied **together** rather than the count
  overriding the threshold. The more restrictive constraint decides;
  passing `NULL` to either falls back to the other. The old defaults
  selected on variance alone at a cut that sits essentially at the
  median of the corrected distribution — measured 1.496 on a Stereo-seq
  cellbin sample, where `1.5` took 9,696 of 19,558 features.
  `var_threshold = 1` is now a noise floor (under Pearson residuals
  variance 1 is the no-signal expectation) rather than a selector, and
  `var_number` sets the size. On a targeted panel, where `var_number`
  cannot bind — Xenium’s 528 features — the floor is what applies,
  keeping the 433 above noise.
- [`findScranMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findScranMarkers_one_vs_all.md)’s
  `logFC` threshold now takes effect. The filter read `logFC >= logFC`,
  where both sides resolved to the result column rather than the
  argument, so the comparison was always `TRUE` and the threshold was
  silently ignored — features were kept on `pval` and `min_feats` alone.
  **Fewer features will be returned than in previous releases**; pass
  `logFC = -Inf` to restore the old behaviour exactly (`logFC = 0` is
  *not* equivalent — it still drops down-regulated features, which the
  broken comparison kept).
- All Leiden entry points now default to `n_iterations = 20`:
  [`doLeidenCluster()`](https://giottosuite.com/dev/reference/doLeidenCluster.md),
  [`doLeidenClusterIgraph()`](https://giottosuite.com/dev/reference/doLeidenCluster.md),
  [`doLeidenClusterPython()`](https://giottosuite.com/dev/reference/doLeidenClusterPython.md),
  [`subClusterCells()`](https://giottosuite.com/dev/reference/subClusterCells.md)
  (was `1000`) and
  [`doLeidenSubCluster()`](https://giottosuite.com/dev/reference/subClusterCells.md)
  (was `500`). Measured ARI 0.97 against the 1000-iteration partition on
  a 159k-cell Xenium dataset, at ~50x the speed. **Cluster IDs will
  differ from previous releases**; pass `n_iterations = 1000` to restore
  the old behaviour.
- [`runUMAP()`](https://giottosuite.com/dev/reference/runUMAP.md) gained
  size-adaptive `n_epochs` and `init`, both now defaulting to `NULL`.
  Above 50,000 observations they resolve to `200` and `"pca"`; below it
  to uwot’s own `n_epochs` default and `"spectral"`. A PCA init
  benchmarked both tighter and faster than a random or spectral init at
  that scale. Passing either explicitly overrides the adaptation.
  `n_epochs` was previously a fixed `400`. **Embeddings above 50,000
  observations will differ from previous releases.**
  [`runUMAPprojection()`](https://giottosuite.com/dev/reference/runUMAPprojection.md)
  and
  [`runIntegratedUMAP()`](https://giottosuite.com/dev/reference/runIntegratedUMAP.md)
  are unchanged and still use `spread = 5, min_dist = 0.01`.
- [`runUMAP()`](https://giottosuite.com/dev/reference/runUMAP.md) now
  uses
  [`uwot::umap2()`](https://jlmelville.github.io/uwot/reference/umap2.html)
  instead of
  [`uwot::umap()`](https://jlmelville.github.io/uwot/reference/umap.html).
  `umap2()` is the same algorithm with a faster approximate
  nearest-neighbor backend selected automatically, and it threads the
  optimizer when `batch = TRUE`. Pass `method = "umap"` to restore the
  previous engine.
- [`runUMAP()`](https://giottosuite.com/dev/reference/runUMAP.md)
  defaults retuned to match the benchmarked streaming pipeline:
  `min_dist` `0.01` -\> `0.05`, `spread` `5` -\> `1`, and a new
  `batch = TRUE` argument (was `FALSE`). `min_dist` and `spread` are
  changed together because uwot fits the embedding’s `a`/`b` curve from
  the pair. `batch = TRUE` is also what lets `umap2()` thread the
  optimizer. **Embeddings will differ from previous releases**;
  `min_dist = 0.01, spread = 5, init = "spectral", n_epochs = 400, batch = FALSE`
  restores the old shape. `n_neighbors` is unchanged at `40`.

### Changes

- gini `min_expr_gini_score` and `min_det_gini_score` renamed
  `min_expression` and `min_detection` — they gate mean expression and
  detection fraction, not the gini coefficients. Old names deprecated.
  [\#1238](https://github.com/drieslab/Giotto/pull/1238) by eryuluts

### New

- `importAtera()` and `createGiottoAteraObject()` read Atera output.
  `AteraReader` subclasses `XeniumReader` — the layouts are identical
  today, so it overrides only the platform label and inherits the rest,
  including `backend =`.
- [`importStereoSeq()`](https://giottosuite.com/dev/reference/importStereoSeq.md),
  [`createGiottoStereoSeqObjectBin()`](https://giottosuite.com/dev/reference/createGiottoStereoSeqObjectBin.md)
  and
  [`createGiottoStereoSeqObjectCell()`](https://giottosuite.com/dev/reference/createGiottoStereoSeqObjectCell.md)
  gained a `backend =` argument. When set to a `gsource` project backend
  it routes to `GiottoDisk::importStereoSeqDisk()`, so a Stereo-seq
  object can be created as a managed on-disk project with expression
  held in a `parquetExprStore` instead of memory — mirroring what
  [`createGiottoXeniumObject()`](https://giottosuite.com/dev/reference/createGiottoXeniumObject.md)
  already did. `backend = NULL` (the default) is a no-op and leaves the
  in-memory path byte-identical. Requires a GiottoDisk carrying the
  matching GEF reader fixes.
- `.stereoseq_build_polygons_from_border()` now populates
  `giottoPolygon@unique_ID_cache`, as every other polygon constructor
  does. This is the one change visible on the in-memory path; the cached
  value equals `unique(poly_ID)` and
  [`spatIDs()`](https://giotto-suite.github.io/GiottoClass/reference/spatIDs-generic.html)
  is unaffected. Left unset, adding cellBorder polygons to a
  backend-managed `giotto` failed, because
  [`setGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/setGiotto.html)
  has by then swapped the `SpatVector` for a `parquetGeomStore` and the
  ID recompute calls [`unique()`](https://rdrr.io/r/base/unique.html) on
  it.
- The `method = "var_p_resid"` diagnostic plot is now decision-support
  rather than a bare scatter: a reference line at `var = 1` (the
  no-signal expectation for Pearson residuals, so the value the
  threshold is relative to), a line at the active `var_threshold`, a
  log10 y-axis so the elbow in a heavy-tailed distribution is visible,
  and a second panel of mean expression against residual variance. That
  panel is the check that selection is not tracking expression level,
  which is what Pearson residuals exist to avoid. The second panel needs
  ; without it the rank view is returned alone.
- `RcppHNSW` and `rnndescent` added to `Suggests`. Either one
  accelerates the
  [`runUMAP()`](https://giottosuite.com/dev/reference/runUMAP.md)
  neighbor search; without them uwot falls back to Annoy. `RcppHNSW` is
  preferred for dense input with a euclidean, cosine or correlation
  metric (the usual
  [`runUMAP()`](https://giottosuite.com/dev/reference/runUMAP.md) case),
  while `rnndescent` covers sparse input and metrics HNSW does not
  support. Installing `rnndescent` is **required** to run
  `runUMAP(dim_reduction_to_use = NULL)` on a sparse expression matrix.
- gini `min_expression_gini` and `min_detection_gini` gate the gini
  coefficients themselves, defaulting to `-Inf`.
  [\#1238](https://github.com/drieslab/Giotto/pull/1238) by eryuluts
- gini `min_length` pads the per-cluster vector so coefficients compare
  across runs with different cluster counts. Defaults to `0`, no
  padding. Replaces the unused `extended_gini_fun()`.
- `analyzeData(x, featStatsParam)` gained `groups` and `stats`, giving
  per-(feature, group) statistics from one pass. Group means are a
  pseudobulk matrix and mean plus percent-detected is dot plot input.
  `groups` may be named or factored by `cell_ID`, which is the only form
  that cannot be misaligned; an unnamed vector is still positional, with
  a warning.
- gini coefficients are taken over all features in one vectorized pass
  instead of one call per feature — 32x faster at 4000 features x 20
  groups, cutting the scoring step 0.31s -\> 0.18s. Results are
  bit-identical. Gini marker detection now errors on fewer than 2
  groups, where it previously failed inside
  [`mygini_fun()`](https://giottosuite.com/dev/reference/mygini_fun.md).
- `markersParam(method = "gini")` and `analyzeData(x, giniMarkersParam)`
  expose gini marker detection as a verb, and now hold the machinery —
  [`findGiniMarkers()`](https://giottosuite.com/dev/reference/findGiniMarkers.md)
  and
  [`findGiniMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findGiniMarkers_one_vs_all.md)
  are thin wrappers that fetch expression and a grouping. Dispatches on
  `ANY` because it is derived entirely from `featStatsParam`, so any
  backend implementing that statistic supplies gini markers with no code
  of its own.
- gini markers and ligand-receptor scoring now run on that verb, so both
  work on disk-backed expression.
  [`findGiniMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findGiniMarkers_one_vs_all.md)
  takes one grouped pass instead of one per cluster (8.9s -\> 4.2s at
  4000 features x 12000 cells x 20 clusters).

### Bug fixes

- gini markers,
  [`findScranMarkers()`](https://giottosuite.com/dev/reference/findScranMarkers.md),
  [`findScranMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findScranMarkers_one_vs_all.md)
  and ligand-receptor scoring now match cluster labels to expression
  columns by `cell_ID`. Expression and cell metadata are fetched
  independently and are not guaranteed to share a cell order, so
  statistics were taken over mislabelled cells — none of the 624 cells
  of `GiottoData::loadGiottoMini("visium")` are in matching position,
  and only 1 of 70 top-10 scran markers agreed with the correctly
  labelled run. **Results will change for affected objects**; they were
  wrong before.
- gini `rank_score` now takes effect. It compared against a rescaled
  rank capped at 1, and
  [`findMarkers_one_vs_all()`](https://giottosuite.com/dev/reference/findMarkers_one_vs_all.md)
  never forwarded it. Default `1` -\> `Inf` keeps results unchanged.
- gini `expression_rank` and `detection_rank` now hold ranks, not the
  `[1, 0.1]` weight behind `comb_score`. Row counts and `comb_score`
  unchanged.

## Giotto 4.2.3 (2026/05/14)

### Changes

- [`createGiottoVisiumHDObject()`](https://giottosuite.com/dev/reference/createGiottoVisiumHDObject.md)
  deprecated, split into:
  - [`createGiottoVisiumHDObjectBin()`](https://giottosuite.com/dev/reference/createGiottoVisiumHDObjectBin.md) -
    binned outputs
  - [`createGiottoVisiumHDObjectCell()`](https://giottosuite.com/dev/reference/createGiottoVisiumHDObjectCell.md) -
    segmented outputs - support optional transcript loading from the 2
    micron bin
- breaking changes to
  [`importVisiumHD()`](https://giottosuite.com/dev/reference/importVisiumHD.md)
- [`doLeidenCluster()`](https://giottosuite.com/dev/reference/doLeidenCluster.md)
  now uses the {igraph} method by default. Original python
  implementation still accessible as
  [`doLeidenClusterPython()`](https://giottosuite.com/dev/reference/doLeidenClusterPython.md)
- Log normalization restricted to `log1p` for sparse-like matrices
  (`dgCMatrix`, `dbSparseMatrix`, `IterableMatrix`) to prevent OOM
  sparse-\>dense conversion

### New

- New StereoSeq reader functions:
  - [`createGiottoStereoSeqObjectBin()`](https://giottosuite.com/dev/reference/createGiottoStereoSeqObjectBin.md) -
    binned outputs
  - [`createGiottoStereoSeqObjectCell()`](https://giottosuite.com/dev/reference/createGiottoStereoSeqObjectCell.md) -
    segmented outputs
- StereoSeq importers: now uses
  [`importStereoSeq()`](https://giottosuite.com/dev/reference/importStereoSeq.md)
  and `StereoSeqReader` object
  - `gef_type` param for unified GEF type selection replacing the old
    auto-detection logic

### Bug fixes

- Update `giottoToAnndataZarr` to use basilisk environments required by
  basilisk v1.22.
- Replace outdated ggplot aes_string with local aes_string2 function.
- Fix usage of outdated parameter in `giottoToSeuratV5`.
- `binarize()` via
  [`processData()`](https://giottosuite.com/dev/reference/processData.md)
  now correctly preserves sparsity for `allMatrix` and `dgCMatrix`
  inputs

### Enhancements

- VisiumHD and StereoSeq memory efficiency improved
- [`calculateHVF()`](https://giottosuite.com/dev/reference/calculateHVF.md)
  speedup via vectorized implementation
- [`calculateHVF()`](https://giottosuite.com/dev/reference/calculateHVF.md)
  `calc_gini` now defaults to `FALSE` to avoid forced dense conversion
  for disk-backed workflows

## Giotto 4.2.2 (2025/06/17)

### Changes

- deprecate
  [`doRandomWalkCluster()`](https://giottosuite.com/dev/reference/doRandomWalkCluster.md)
  and
  [`doSNNCluster()`](https://giottosuite.com/dev/reference/doSNNCluster.md).
  These functions will be removed soon.
- switch to clustering framework based on {bluster} via
  [`clusterData()`](https://giottosuite.com/dev/reference/clusterData.md)
  and
  [`clusterParam()`](https://giottosuite.com/dev/reference/clusterParam.md)

### Bug fixes

- fix fov shift detection logic in CosMx imports
  [\#1168](https://github.com/drieslab/Giotto/pull/1168) by jral3s
- fix fov shift inference logic in CosMx imports
  [\#1169](https://github.com/drieslab/Giotto/pull/1169) by jral3s

## Giotto 4.2.1 (2025/05/06)

### Changes

- GiottoUtils req raised to 0.2.4
- terra req raised to 1.8-21

### Bug fixes

- fix
  [`identifyTMAcores()`](https://giottosuite.com/dev/reference/identifyTMAcores.md)
  when no overlap relations are found and an `rbind` error is thrown
- fix
  [`createGiottoCosMxObject()`](https://giottosuite.com/dev/reference/createGiottoCosMxObject.md)
  not passing `load_expression`, `load_cellmeta`, `load_transcripts`
  params to
  [`importCosMx()`](https://giottosuite.com/dev/reference/importCosMx.md)
- fix convenience functions for {terra} `v1.8-21`
- fix `Giotto::` scoped calls for functions that call
  [`update_giotto_params()`](https://giotto-suite.github.io/GiottoClass/reference/update_giotto_params.html)

### Enhancements

- `poly_pref` param for
  [`createGiottoCosMxObject()`](https://giottosuite.com/dev/reference/createGiottoCosMxObject.md)
  and
  [`importCosMx()`](https://giottosuite.com/dev/reference/importCosMx.md)
  to select between loading the mask images or the `polygons.csv` as
  polygon info.
- `image_negative_y` param for
  [`createGiottoCosMxObject()`](https://giottosuite.com/dev/reference/createGiottoCosMxObject.md)
  for toggling how images and polygons from mask images should be
  spatially mapped
- `slide` param made more prominent in
  [`createGiottoCosMxObject()`](https://giottosuite.com/dev/reference/createGiottoCosMxObject.md)
- [`importCosMx()`](https://giottosuite.com/dev/reference/importCosMx.md)
  now supports vectors of filepaths when provided to `$load_images()`
  and `$load_polys()`
- [`importCosMx()`](https://giottosuite.com/dev/reference/importCosMx.md)
  Selected FOVs are now selected in
  [`plot()`](https://rdrr.io/r/base/plot.html).
- performance improvements for default normalization workflow

### New

- [`processExpression()`](https://giottosuite.com/dev/reference/processExpression.md)
  for `giotto` implemented via the
  [`processData()`](https://giottosuite.com/dev/reference/processData.md)
  framework in {GiottoClass} v0.4.7 (see
  [`?processData`](https://giottosuite.com/dev/reference/processData.md)
  and
  [`?process_param`](https://giottosuite.com/dev/reference/process_param.md))
- `arcsinh`, `L2`, and `TF-IDF` normalization methods accessible via the
  [`processData()`](https://giottosuite.com/dev/reference/processData.md)
  framework
- [`runIterativeLSI()`](https://giottosuite.com/dev/reference/runIterativeLSI.md)
  based on {ArchR} implementation

## Giotto 4.2.0 (2025/01/17)

### Breaking Changes

- Large changes to
  [`createGiottoCosMxObject()`](https://giottosuite.com/dev/reference/createGiottoCosMxObject.md)
  that better reflect NanoString provided outputs.
- Param naming changes for segmentation wrapper functions
  [`doMesmerSegmentation()`](https://giottosuite.com/dev/reference/doMesmerSegmentation.md),
  [`doCellposeSegmentation()`](https://giottosuite.com/dev/reference/doCellposeSegmentation.md)
  [`doStardistSegmentation()`](https://giottosuite.com/dev/reference/doStardistSegmentation.md)

### Bug fixes

- fix
  [`importCosMx()`](https://giottosuite.com/dev/reference/importCosMx.md)
  fov shifts file detection
- fix micron scaling for
  [`importCosMx()`](https://giottosuite.com/dev/reference/importCosMx.md)
- [`callSpdep()`](https://giottosuite.com/dev/reference/callSpdep.md)
  should also automatically convert *Matrix* classes to `listw`

### Enhancements

- new `stats` param in
  [`addStatistics()`](https://giottosuite.com/dev/reference/addStatistics.md)
  to control which statistics are calculated.
- `"area"` calculation added as an
  [`addStatistics()`](https://giottosuite.com/dev/reference/addStatistics.md)
  `stats` selection
- [`adjustGiottoMatrix()`](https://giottosuite.com/dev/reference/adjustGiottoMatrix.md)
  now outputs a `Matrix` structure instead of a base `matrix`

### Changes

- GiottoUtils req raised to 0.2.3
- [`adjustGiottoMatrix()`](https://giottosuite.com/dev/reference/adjustGiottoMatrix.md)
  `update_slot` param deprecated in favor of `name`.

## Giotto 4.1.6 (2024/12/09)

### Bug fixes

- [`doScrubletDetect()`](https://giottosuite.com/dev/reference/doScrubletDetect.md)
  seed setting

### Enhancements

- [`labelTransfer()`](https://giottosuite.com/dev/reference/labelTransfer.md)
  now has `integration_method = "harmony"` for label transferring with
  an integration pipeline. See ?labelTransfer and the
  `integration_method` section.
- [`importXenium()`](https://giottosuite.com/dev/reference/importXenium.md)
  `load_transcripts()` can now return a `data.table` rather than the
  `giottoPoints` representation

### New

- [`doMesmerSegmentation()`](https://giottosuite.com/dev/reference/doMesmerSegmentation.md)
  and
  [`doStardistSegmentation()`](https://giottosuite.com/dev/reference/doStardistSegmentation.md)
  segmentation wrappers
- `.varexp()` internal for calculating SVD variance determined with
  support for partial SVDs
- `.cumvar()` internal for calculating cumulative variance explained
- re-export of
  [`dotPlot()`](https://giotto-suite.github.io/GiottoVisuals/reference/dotPlot.html)
  from GiottoVisuals

### Changes

- GiottoUtils req raised to 0.2.2
- GiottoClass req raised to 0.4.5
- GiottoVisuals req raised to 0.2.10

## Giotto 4.1.5 (2024/11/08)

### Enhancements

- [`createGiottoXeniumObject()`](https://giottosuite.com/dev/reference/createGiottoXeniumObject.md)
  auto loading for morphology focus images, image directory loading,
  auto centroid calculation, allow skipping transcript loading

### Website changes

- New Analysis mini tutorials for showing common processing functions
  independently of the spatial technology.
- New Slide-seq and OpenST examples.
- New Contributing tab with guidelines for contributing to the package
  and the website.
- New Visualizations tutorials.
- New Giotto workflow and Core Functions tutorials under Get Started
  tab.
- New Create and change Giotto instructions tutorial.
- New Spatial Patterns tutorials section.
- New tutorials under Interactivity for regions selection with
  vitessceR.
- New Multi-samples tutorials section.
- Updated technologies examples.
- Updated tutorials for using Docker and Singularity Giotto containers.
- Homogenized variable names across examples and tutorials.

## Giotto 4.1.4 (2024/10/30)

### Changes

- [`createGiottoVisiumObject()`](https://giottosuite.com/dev/reference/createGiottoVisiumObject.md)
  apply a modifier of 0.8461538 to visium spot diameter to reflect
  actual spot size
- [`doLeidenClusterIgraph()`](https://giottosuite.com/dev/reference/doLeidenCluster.md)
  deprecate param `resolution_parameter` in favor of `resolution`

### Enhancements

- [`createGiottoVisiumObject()`](https://giottosuite.com/dev/reference/createGiottoVisiumObject.md)
  append multiplicative scalefactor to get micron values from the
  current coordinate units during Visium object creation. Accessible
  through `instructions(gobject, "micron_scale")`

## Giotto 4.1.3 (2024/10/27)

### New

- Add
  [`giottoToAnndataZarr()`](https://giottosuite.com/dev/reference/giottoToAnndataZarr.md)
  to create a local anndata zarr folder and interact with the vitessceR
  package.
- [`reduceDims()`](https://giottosuite.com/dev/reference/reduceDims.md)
  API function for dimension reductions
- [`runNMF()`](https://giottosuite.com/dev/reference/runNMF.md)
  implementation that works via RcppML

### Changes

- [`runWNN()`](https://giottosuite.com/dev/reference/runWNN.md) and
  [`runIntegratedUMAP()`](https://giottosuite.com/dev/reference/runIntegratedUMAP.md)
  arguments were updated to make the function flexible to handle any
  number of modalities.
- update
  [`jackstrawPlot()`](https://giottosuite.com/dev/reference/jackstrawPlot.md)
  to make more flexible and efficient. Changed default params for
  `scaling`, `centering`, and `feats_to_use` to match
  [`runPCA()`](https://giottosuite.com/dev/reference/runPCA.md)
- change warning when reduction “feats” is selected in
  [`runtSNE()`](https://giottosuite.com/dev/reference/runtSNE.md) to
  error to avoid accidentally wiping the `giotto` object.

## Giotto 4.1.2

### Breaking changes

- remove deprecated `PAGEEnrich()`. Use
  [`runPAGEEnrich()`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)
  instead
- remove deprecated `rankEnrich()`. Use
  [`runRankEnrich()`](https://giottosuite.com/dev/reference/runRankEnrich.md)
  instead
- remove deprecated `hyperGeometricEnrich()`. Use
  [`runHyperGeometricEnrich()`](https://giottosuite.com/dev/reference/runHyperGeometricEnrich.md)
  instead
- remove deprecated `createSpatialEnrich()`. Use
  [`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)
  instead
- remove deprecated `heatmSpatialCorGenes()`. Use
  [`heatmSpatialCorFeats()`](https://giottosuite.com/dev/reference/heatmSpatialCorFeats.md)
  instead
- remove deprecated `runPAGEEnrich_OLD()`. Use
  [`runPAGEEnrich()`](https://giottosuite.com/dev/reference/enrichment_PAGE.md)
  instead
- remove `do_pca`, `expression_values`, `feats_to_use` args from
  [`runGiottoHarmony()`](https://giottosuite.com/dev/reference/runGiottoHarmony.md).
  Running PCA during the `harmony::RunHarmony()` call is deprecated.

### Enhancements

- add `'quantile'` normalization method to
  [`normalizeGiotto()`](https://giottosuite.com/dev/reference/normalizeGiotto.md)

### Changes

- `limma`, `plotly`, and `Rtsne` moved to Suggests
- move `progressr` and `jsonlite` dependencies to GiottoUtils v0.1.12
- remove `reshape2` dependency.

### Bug fixes

- [`processGiotto()`](https://giottosuite.com/dev/reference/processGiotto.md)
  can now skip adjust step by default

### New

- [`identifyTMAcores()`](https://giottosuite.com/dev/reference/identifyTMAcores.md)
  for assigning IDs to tissue microarray spatial data.
- [`labelTransfer()`](https://giottosuite.com/dev/reference/labelTransfer.md)
  for transferring labels between giotto objects or subsets thereof.
  Supercedes
  [`doClusterProjection()`](https://giottosuite.com/dev/reference/doClusterProjection.md)

## Giotto 4.1.1

### Bug fixes

- Allow `giottoInstructions` passing for Xenium convenience functions

### Changes

- Deprecate
  [`screePlot()`](https://giottosuite.com/dev/reference/screePlot.md)
  `name` in favor of `dim_reduction_name` param

## Giotto 4.1.0 (2024/07/31)

### Breaking changes

- Deprecated `detectSpatialCorGenes()` removed. Use
  [`detectSpatialCorFeats()`](https://giottosuite.com/dev/reference/detectSpatialCorFeats.md)
  instead
- Deprecated
  [`findInteractionChangedGenes()`](https://giottosuite.com/dev/reference/findInteractionChangedGenes.md)
  removed. Use
  [`findInteractionChangedFeats()`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)
  instead
- Deprecated
  [`findCellProximityGenes()`](https://giottosuite.com/dev/reference/findCellProximityGenes.md)
  removed. Use
  [`findInteractionChangedFeats()`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)
  instead
- [`createGiottoXeniumObject()`](https://giottosuite.com/dev/reference/createGiottoXeniumObject.md)
  has been overhauled and parameters have changed.

### Bug fixes

- Fix error in
  [`plotInteractivePolygons()`](https://giottosuite.com/dev/reference/plotInteractivePolygons.md)
  when providing a spatial plot with a continuous scale
  [\#964](https://github.com/drieslab/Giotto/issues/964) by jweis3
- Fix error in DWLS
  [`find_dampening_constant()`](https://giottosuite.com/dev/reference/find_dampening_constant.md)
  when `S[subset, ]` produces only 1 gene.
- Fix error in `interpolateFeatures()` where feature names with `-` or
  starting with numbers did not work
- Add catch in
  [`runPCAprojectionBatch()`](https://giottosuite.com/dev/reference/runPCAprojectionBatch.md)
  for when ncp requested exceeds number of feats used
- Make
  [`spatCellCellcom()`](https://giottosuite.com/dev/reference/spatCellCellcom.md)
  respect `verbose` flag
  [\#949](https://github.com/drieslab/Giotto/issues/949) by rbutleriii

### New

- Dataset affine registration via interactive shiny app and automated
  SIFT detection
- Cell segmentation via Cellpose
- [`read10xAffineImage()`](https://giottosuite.com/dev/reference/read10xAffineImage.md)
  for reading 10x affine transformed images
- Several modular importer and convenience functions
- ONTraC implementation

### Enhancements

- [`print()`](https://rdrr.io/r/base/print.html) methods for `icfObject`
  and `combIcfObject`

### Changes

- require GiottoUtils (\>= 0.1.10)
- require GiottoClass (\>= 0.3.3)

## Giotto 4.0.8 (2024/05/22)

### Breaking changes

- `crossSectionGenePlot()` removed. Use
  [`crossSectionFeatPlot()`](https://giottosuite.com/dev/reference/crossSectionFeatPlot.md)
  instead
- `crossSectionGenePlot3D()` removed. Use
  [`crossSectionFeatPlot3D()`](https://giottosuite.com/dev/reference/crossSectionFeatPlot3D.md)
  instead
- `insertCrossSectionGenePlot3D()` removed Use
  [`insertCrossSectionFeatPlot3D()`](https://giottosuite.com/dev/reference/insertCrossSectionFeatPlot3D.md)
  instead

### Bug fixes

- [`binSpect()`](https://giottosuite.com/dev/reference/binSpect.md)
  param passing error introduced in *v4.0.6*
- updated
  [`viewHMRFresults3D()`](https://giottosuite.com/dev/reference/viewHMRFresults3D.md)
  and
  [`viewHMRFresults2D()`](https://giottosuite.com/dev/reference/viewHMRFresults2D.md)
- updated `createCrossSections()`,
  [`insertCrossSectionSpatPlot3D()`](https://giottosuite.com/dev/reference/insertCrossSectionSpatPlot3D.md),
  [`crossSectionPlot()`](https://giottosuite.com/dev/reference/crossSectionPlot.md),
  [`crossSectionFeatPlot3D()`](https://giottosuite.com/dev/reference/crossSectionFeatPlot3D.md),
  [`insertCrossSectionFeatPlot3D()`](https://giottosuite.com/dev/reference/insertCrossSectionFeatPlot3D.md),
  [`crossSectionPlot3D()`](https://giottosuite.com/dev/reference/crossSectionPlot3D.md),
  [`crossSectionFeatPlot()`](https://giottosuite.com/dev/reference/crossSectionFeatPlot.md)

### Changes

- GiottoVisuals (\>= 0.2.2), GiottoClass (\>= 0.3.1), GiottoUtils (\>=
  0.1.8) are now required.

## Giotto 4.0.6 (2024/05/13)

### Enhancements

- New
  [`interpolateFeature()`](https://giottosuite.com/dev/reference/interpolateFeature.md)
  for kriging interpolation of values

### Changes

- GiottoVisuals (\>= 0.2.0) and GiottoClass (\>= 0.3.0) are now
  required.

## Giotto 4.0.5 (2024/03/12)

### Bug fixes

- Fix Error “cannot coerce class ‘structure(”spatLocsObj”, package =
  “Giotto”)’ to a data.frame” in
  [`spatialDE()`](https://giottosuite.com/dev/reference/spatialDE.md)

### Enhancements

- [`readPolygonVizgenParquet()`](https://giottosuite.com/dev/reference/readPolygonVizgenParquet.md)
  now has `calc_centroids = TRUE` by default

## Giotto 4.0.4 (2024/02/28)

### Breaking changes

- Remove `do_manual_adj` and image adjustment params from
  [`createGiottoVisiumObject()`](https://giottosuite.com/dev/reference/createGiottoVisiumObject.md)
- [`createGiottoVisiumObject()`](https://giottosuite.com/dev/reference/createGiottoVisiumObject.md)
  now creates `giottoLargeImage` for spatial images.
- [`exprCellCellcom()`](https://giottosuite.com/dev/reference/exprCellCellcom.md)
  deprecated `gene_set_*` params removed

### Bug fixes

- Fix metadata appending/sorting issues introduced by *GiottoClass
  v0.1.3* (2024/01/12). Affected functions:
  [`addHMRF()`](https://giottosuite.com/dev/reference/addHMRF.md),
  [`addFeatsPerc()`](https://giottosuite.com/dev/reference/addFeatsPerc.md),
  [`doScrubletDetect()`](https://giottosuite.com/dev/reference/doScrubletDetect.md)
- [`findNetworkNeighbors()`](https://giottosuite.com/dev/reference/findNetworkNeighbors.md)
  now has default `spatial_network_name` value of `NULL`
- [`get10Xmatrix()`](https://giottosuite.com/dev/reference/get10Xmatrix.md)
  now obeys `split_by_type = FALSE`

### Changes

- Deprecate `set.seed` in favor of `seed` param for
  [`binSpect()`](https://giottosuite.com/dev/reference/binSpect.md)
- [`binSpect()`](https://giottosuite.com/dev/reference/binSpect.md) now
  sets a seed by default for reproducibility
- pkgdown files moved to separate
  [repo](https://github.com/drieslab/Giotto_website)

### Enhancements

- Use `mixedsort()` for unique clusters metadata info
- Remove unnecessary matrix densification and expose `seed` param in
  [`doScrubletDetect()`](https://giottosuite.com/dev/reference/doScrubletDetect.md)
- Remove unnecessary matrix densification in
  [`makeSignMatrixRank()`](https://giottosuite.com/dev/reference/makeSignMatrixRank.md)

## Giotto 4.0.3 (2024/02/20)

### Bug fixes

- Remove old argument
  `type_default = list(pal = c('blue', 'yellow', 'red'))` in
  plotRankSpatvsExpr()

## Giotto 4.0.2 (2023/12/21)

### Bug Fixes

- fix bug in
  [`doHclust()`](https://giottosuite.com/dev/reference/doHclust.md)

### Changes

- Move *GiottoClass* back to depends to fix access to some generics

## Giotto 4.0.1 (2023/12/16)

### Breaking changes

- Remove `cell_ids` param for
  [`calculateHVF()`](https://giottosuite.com/dev/reference/calculateHVF.md)
  in favor of simpler `random_subset`
- Move *GiottoUtils*, *GiottoClass*, and *GiottoVisuals* to imports

### Added

- Add `parse_affine()` for interpreting affine transform matrices
- Add seed setting to
  [`runGiottoHarmony()`](https://giottosuite.com/dev/reference/runGiottoHarmony.md)
- Add parallelized calculation for
  [`calculateHVF()`](https://giottosuite.com/dev/reference/calculateHVF.md)
  when a *future* plan is set

### Changes

- Fix
  [`createGiottoXeniumObject()`](https://giottosuite.com/dev/reference/createGiottoXeniumObject.md)
  feature metadata reading for `.json` file
- Update
  [`runGiottoHarmony()`](https://giottosuite.com/dev/reference/runGiottoHarmony.md)
  to call `harmony::RunHarmony()`
- Update *Matrix* requirement to \>= 1.6.2 (a re-install of *irlba* may
  resolve issues with Matrix incompatibility.)

## Giotto 4.0.0 (2023/11/29)

### Breaking changes

- Update to modular package organization with the main packages being
  `GiottoUtils`, `GiottoClass`, `GiottoVisuals`, and `Giotto` as the
  analytical umbrella package.

### Added

- New File `spatial_enrichment_visuals.R`
- New function
  [`findCellTypesFromEnrichment()`](https://giottosuite.com/dev/reference/findCellTypesFromEnrichment.md)
  within `spatial_enrichment_visuals.R` to show most probable cell types
  based on a provided enrichment
- New function
  [`plotCellTypesFromEnrichment()`](https://giottosuite.com/dev/reference/plotCellTypesFromEnrichment.md)
  within `spatial_enrichment_visuals.R` that generates a bar plot of
  cell types vs frequency based on a provided enrichment
- New function
  [`pieCellTypesFromEnrichment()`](https://giottosuite.com/dev/reference/pieCellTypesFromEnrichment.md)
  within `spatial_enrichment_visuals.R` that generates a pie chart of
  cell types based on a provided enrichment
- New function
  [`addVisiumPolygons()`](https://giottosuite.com/dev/reference/addVisiumPolygons.md)
  within `convenience.R` (along with its requisite internal functions)
  that adds circular polygons centered at the spatial locations of a
  Giotto Object made with Visium data. Takes a Giotto Object and a path
  to the Visium output file `scalefactors_json.json` as input arguments.
- Added
  [`addVisiumPolygons()`](https://giottosuite.com/dev/reference/addVisiumPolygons.md)
  to
  [`createGiottoVisiumObject()`](https://giottosuite.com/dev/reference/createGiottoVisiumObject.md)
  workflow.
- Add `cell_ids` param to
  [`calculateHVF()`](https://giottosuite.com/dev/reference/calculateHVF.md)
  to allow calculation of HVFs on a subset of cells
- Add seed setting to
  [`runGiottoHarmony()`](https://giottosuite.com/dev/reference/runGiottoHarmony.md)
- Update
  [`runGiottoHarmony()`](https://giottosuite.com/dev/reference/runGiottoHarmony.md)
  to call `harmony::RunHarmony()`

### Changes

- Update *Matrix* requirement to \>= 1.6.3

## Giotto 3.3.1 (2023/08/02)

### Breaking changes

- Change
  [`checkGiottoEnvironment()`](https://giotto-suite.github.io/GiottoClass/reference/giotto_python.html).
  Downgrade from error to message and return FALSE when a provided
  directory does not exist

### Added

- New file `poly_influence.R`
- New function
  [`showPolygonSizeInfluence()`](https://giottosuite.com/dev/reference/showPolygonSizeInfluence.md)
  within `poly_influence.R` to show if cells switch clusters when across
  resized polygon annotations
- New function
  [`showCellProportionSwitchedPie()`](https://giottosuite.com/dev/reference/showCellProportionSwitchedPie.md)
  within `poly_influence.R` to visualize results from
  [`showPolygonSizeInfluence()`](https://giottosuite.com/dev/reference/showPolygonSizeInfluence.md)
  in a pie chart
- New function `showCellProportionSwitchedSankey()` within
  `poly_influence.R` to visualize results from
  [`showPolygonSizeInfluence()`](https://giottosuite.com/dev/reference/showPolygonSizeInfluence.md)
  in a Sankey diagram
- New function
  [`makePseudoVisium()`](https://giotto-suite.github.io/GiottoClass/reference/makePseudoVisium.html)
  within `giotto_structure.R` to generate a pseudo visium grid of
  circular spots
- New function
  [`tessellate()`](https://giotto-suite.github.io/GiottoClass/reference/tessellate.html)
  within `giotto_structure.R` to generate a grid of hexagons or squares
  for spatial binning
- New file `feature_set_enrichment.R`
- New function
  [`doFeatureSetEnrichment()`](https://giottosuite.com/dev/reference/doFeatureSetEnrichment.md)
  within `feature_set_enrichment.R` for GSEA analysis
- New function
  [`doGiottoClustree()`](https://giottosuite.com/dev/reference/doGiottoClustree.md)
  within `clustering.R` for visualizations of leiden clusters at varying
  resolutions
- New
  [`createArchRProj()`](https://giottosuite.com/dev/reference/createArchRProj.md)
  and `CreateGiottoObjectFromArchR()` functions to create a `giotto`
  object with ATAC or epigenetic features using the *ArchR* pipeline.
- New
  [`giottoMasterToSuite()`](https://giotto-suite.github.io/GiottoClass/reference/giottoMasterToSuite.html)
  function to convert a `giotto` object created with the master version
  to a Giotto suite object.
- New
  [`readPolygonVizgenParquet()`](https://giottosuite.com/dev/reference/readPolygonVizgenParquet.md)
  for updated parquet outputs
- Add *checkmate* to Imports for assertions checking
- Add exported `create` function for `exprObj` creation
- New file `spatial_manipulation.R`
- Add [`ext()`](https://rspatial.github.io/terra/reference/ext.html)
  methods for `giottoPolygon`, `giottoPoints`, `spatialNetworkObj`,
  `spatLocsObj`, `giottoLargeImage`
- Add [`flip()`](https://rspatial.github.io/terra/reference/flip.html)
  methods for `giottoPolygon`, `giottoPoints`, `spatialNetworkObj`,
  `spatLocsObj`, `SpatExtent`, `giottoLargeImage`
- Add access to terra plotting params for `giottoLargeImage`
  [`plot()`](https://rdrr.io/r/base/plot.html) method.

### Changes

- Fix bug in `combine_matrices()`
- Fix bug in
  [`createGiottoObject()`](https://giotto-suite.github.io/GiottoClass/reference/create_giotto.html)
  that will not allow object creation without supplied expression
  information
- Updated
  [`polyStamp()`](https://giotto-suite.github.io/GiottoClass/reference/polyStamp.html)
  to replace an apply function with a crossjoin for better performance.
- Updated
  [`spatInSituPlotPoints()`](https://giotto-suite.github.io/GiottoVisuals/reference/spatInSituPlotPoints.html)
  with `plot_last` parameter. Default output now plots polygons above
  points for better visibility.
- Add check for spatLocsObj for spatlocs in polyStamp()
- Removed various print() and cat() statements throughout.
- Changed default verbose argument to FALSE for createGiottoObject
- Changed default verbose argument to FALSE for joinGiottoObjects
- Changed default verbose argument to FALSE for
  createGiottoObjectSubcellular
- Default verbose = FALSE argument added to cellProximityEnrichmentSpots
- Default verbose = FALSE argument added to .specific_CCCScores_spots
- Default verbose = FALSE argument added to runWNN
- Default verbose = FALSE argument added to subset_giotto_points_object
- Default verbose = FALSE argument added to subset_feature_info_data
- Default verbose = FALSE argument added to subsetGiotto
- Default verbose = FALSE argument added to subsetGiottoLocsSubcellular
- Default verbose = FALSE argument added to
  .createGiottoXeniumObject_subcellular
- Update
  [`readPolygonFilesVizgenHDF5()`](https://giottosuite.com/dev/reference/readPolygonFilesVizgenHDF5.md)
  add option to return as `data.table` and skip `giottoPolygon`
  creation. Downstream `giottoPolygon` creation refactored as new
  internal function
- Update cell segmentation workflow to check for *deepcell* and *PIL*
  python packages
- Update cell segmentation workflow to return grayscale mask images
  instead of RGB
- Update
  [`createGiottoVisiumObject()`](https://giottosuite.com/dev/reference/createGiottoVisiumObject.md)
  image h5 scalefactors reading to use partial matching for whether hi
  or lowres image is supplied
- Update `giottoLargeImage` [`plot()`](https://rdrr.io/r/base/plot.html)
  method to use
  [`terra::plot()`](https://rspatial.github.io/terra/reference/plot.html)
  instead of
  [`terra::plotRGB()`](https://rspatial.github.io/terra/reference/plotRGB.html)
  for grayscale images
- Remove unnecessary prints from
  [`subsetGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/subsetGiotto.html)
- Fix bug in
  [`readCellMetadata()`](https://giotto-suite.github.io/GiottoClass/reference/readCellMetadata.html)
  and
  [`readFeatMetadata()`](https://giotto-suite.github.io/GiottoClass/reference/readFeatMetadata.html)

## Giotto 3.3.0 (2023/04/18)

### Breaking changes

- Set Suite as default branch
- Removed all deprecated accessors from `accessors.R`
- [`set_default_feat_type()`](https://giotto-suite.github.io/GiottoClass/reference/set_default_feat_type.html)
  error downgraded to warning when no `feat_type`s exist for given
  `spat_unit`
- update
  [`loadGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/loadGiotto.html)
  and
  [`saveGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/saveGiotto.html)
  to allow using long strings as column names in the spatVector objects
- `'active_spat_unit'` and `'active_feat_type'` params that can be set
  through
  [`instructions()`](https://giotto-suite.github.io/GiottoClass/reference/giotto_instructions.html)
  are now used instead of ‘giotto.spat_unit’ and ‘giotto.feat_type’
  global options
- removed duplicate `create_dimObject()` internal function. Keeping
  `create_dim_obj()`

### Added

- New implementations of
  [`anndataToGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/anndataToGiotto.html)
  and
  [`giottoToAnnData()`](https://giotto-suite.github.io/GiottoClass/reference/giottoToAnnData.html)
  for Nearest Neighbor and Spatial Networks
- New `check_py_for_scanpy()` function, shifting code around in
  [`anndataToGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/anndataToGiotto.html)
- Add [`initialize()`](https://rdrr.io/r/methods/new.html) method for
  `giotto`
- Add exported `create` constructor functions for Giotto S4 subobjects
- Add
  [`activeSpatUnit()`](https://giotto-suite.github.io/GiottoClass/reference/activeSpatUnit-generic.html)
  and
  [`activeFeatType()`](https://giotto-suite.github.io/GiottoClass/reference/activeFeatType-generic.html)
  for getting and setting active defaults on gobject
- New `get_*_list()` internal functions for retrieving list of all
  objects of a particular class for a spat_unit and feat_type
- Add
  [`instructions()`](https://giotto-suite.github.io/GiottoClass/reference/giotto_instructions.html)
  generic for `giotto` to access and edit `giottoInstructions`
- Add
  [`centroids()`](https://rspatial.github.io/terra/reference/centroids.html)
  method for `giottoPolygon` to get centroid info
- Add
  [`overlaps()`](https://giotto-suite.github.io/GiottoClass/reference/overlaps-generic.html)
  generic for accessing `overlaps` slot of `giottoPolygon`
- Add `[` and `[<*` (empty) access generics to get the data from main
  slots of `giottoPolygon` and `giottoPoints`
- Add cores detection to run on package attach.
  (`getOption('giotto.cores')`)
- Add option to return as `giottoPoints` from `getFeatureInfo` (default
  is still `SpatVector`)
- Add `spatVector_to_dt2` internal as a barebones alternative to
  `spatVector_to_dt()`
- Add
  [`getRainbowColors()`](https://giotto-suite.github.io/GiottoUtils/reference/getRainbowColors.html)
  color palette
- New `assign_objnames_2_list()` and `assign_listnames_2_obj()`
  internals for passing list names to object `@name` slots and vice
  versa
- New test_that `test_createObject.R` script for `read` functions/S4
  subobject creation
- New test_that `test_accessors.R` script for `accessor` functions
- New test_that `test_gobject.R` script for gobject consistency checks

### Changes

- Update
  [`installGiottoEnvironment()`](https://giotto-suite.github.io/GiottoClass/reference/giotto_python.html)
  and downstream internal functions to allow custom python installation
  with a new argument, `mini_install_path`.
- Update
  [`checkGiottoEnvironment()`](https://giotto-suite.github.io/GiottoClass/reference/giotto_python.html)
  to account for custom python installations with a new argument,
  `mini_install_path`.
- Update
  [`removeGiottoEnvironment()`](https://giotto-suite.github.io/GiottoClass/reference/giotto_python.html)
  to account for custom python installations with a new argument,
  `mini_path`.
- Update
  [`createGiottoObject()`](https://giotto-suite.github.io/GiottoClass/reference/create_giotto.html)
  with new data ingestion pipeline
- Modify `cell_ID`, `feat_ID`, `cell_metadata`, `feat_metadata` slot
  initialization
- Update `read_expression_data()` and `evaluate_expr_matrix()` to be
  compatible with `exprObj`
- Change
  [`changeGiottoInstructions()`](https://giotto-suite.github.io/GiottoClass/reference/changeGiottoInstructions.html)
  to allow addition of new params and enforce logical class of known
  params
- Update and fix bugs in
  [`createGiottoCosMxObject()`](https://giottosuite.com/dev/reference/createGiottoCosMxObject.md)
  associated with polygon placement and generation
- Update [`plot()`](https://rdrr.io/r/base/plot.html) for `giottoPoints`
  with faster rasterized plotting option. (Now used by default)
- Fix bug in
  [`doLouvainCluster()`](https://giottosuite.com/dev/reference/doLouvainCluster.md)
  (sub)functions and made them compatible with new Giotto Suite
  framework.
- Fix bug in
  [`gefToGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/gefToGiotto.html)
  bin_size arguments.
- Update
  [`loadGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/loadGiotto.html)
  and
  [`saveGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/saveGiotto.html)
  with path.expand to expand provided file/directory paths
- Organize new and refactored slot `check` functions in `giotto.R` for
  checking gobject consistency during
  [`initialize()`](https://rdrr.io/r/methods/new.html)
- Organize new and refactored `evaluate` functions in
  `data_evaluation.R` for data wrangling of external data
- Organize new and refactored `read` functions in `data_input.R` for
  ingesting data and converting to list of Giotto native S4 subobjects
- Organize dummy documentation in `dd.R` for inheriting commonly used
  documentation
- Moved `create_featureNetwork_object()`,
  `create_giotto_points_object()`, `create_giotto_polygon_object()` to
  classes.R
- Moved [`depth()`](https://rdrr.io/r/grid/depth.html) from giotto.R to
  utilities.R

## Giotto 3.2.0 (2023/02/02)

### Breaking changes

- Removed support for deprecated nesting in `@nn_network` slot
- [`createSpatialNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/createSpatialNetwork.html)
  will now output a `spatialNetworkObj` by default when
  `return_gobject = FALSE`. It is possible to change this back to the
  data.table output by setting `output = 'data.table'`
- Set incomplete classes in classes.R as virtual to prevent their
  instantiation
- Removed
  [`createGiottoCosMxObject()`](https://giottosuite.com/dev/reference/createGiottoCosMxObject.md)
  `aggregate` and `all` workflows until they are updated

### Added

- New
  [`gefToGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/gefToGiotto.html)
  interoperability function to convert gef object from Stereo\*seq to
  giotto
- New
  [`giottoToAnnData()`](https://giotto-suite.github.io/GiottoClass/reference/giottoToAnnData.html)
  interoperability function to convert giotto object to squidpy flavor
  anndata .h5ad file(s)
- New
  [`giottoToSpatialExperiment()`](https://giotto-suite.github.io/GiottoClass/reference/giottoToSpatialExperiment.html)
  and
  [`spatialExperimentToGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/spatialExperimentToGiotto.html)
  to convert between Giotto and SpatialExperiment
- New
  [`spatialAutoCorLocal()`](https://giottosuite.com/dev/reference/spatialAutoCor.md)
  and
  [`spatialAutoCorGlobal()`](https://giottosuite.com/dev/reference/spatialAutoCor.md)
  functions to find spatial autocorrelations from expression and cell
  metadata information
- New
  [`createSpatialWeightMatrix()`](https://giotto-suite.github.io/GiottoClass/reference/createSpatialWeightMatrix.html)
  function to generate spatial weight matrix from spatial networks for
  autocorrelation
- Add spatial_interaction_spot.R with functions adapted from master
  branch for working with the Giotto suite object.
- New exported accessors for slots (experimental)
- New `multiomics` slot in `giotto`
- Add `coord_fix_ratio` param to
  [`spatFeatPlot2D()`](https://giotto-suite.github.io/GiottoVisuals/reference/spatFeatPlot2D.html)
  and
  [`spatFeatPlot2D_single()`](https://giotto-suite.github.io/GiottoVisuals/reference/spatFeatPlot2D_single.html)
- Add `order` parameter to `dimFeatPlot2D` and `spatDimFeatPlot2d` to
  plot and order cells according to the levels of the selected feature
  ([\#477](https://github.com/drieslab/Giotto/issues/477))
- Add [`plot()`](https://rdrr.io/r/base/plot.html) method for
  `spatialNetworkObj`
- New `set_row_order_dt()` internal for setting `data.table` to a
  specific row order by reference
- New `fread_colmatch()` internal for fread loading a subset of rows
  based on matches in a specified column
- Add missing `create_nn_net_obj()` internal constructor function for S4
  `nnNetObj`
- Add `id_col`, `x_col`, `y_col` params to
  [`polyStamp()`](https://giotto-suite.github.io/GiottoClass/reference/polyStamp.html)
  to make stamp location input more flexible
- Add `optional` and `custom_msg` params to `package_check()`
- New [`wrap()`](https://rspatial.github.io/terra/reference/wrap.html)
  and [`vect()`](https://rspatial.github.io/terra/reference/vect.html)
  generics for `giotto`, `giottoPoints`, and `giottoPolygons`
- New `rotate()`, [`t()`](https://rdrr.io/r/base/t.html), and
  `spatShift` generics for giotto subobject spatial manipulation
- New
  [`spatIDs()`](https://giotto-suite.github.io/GiottoClass/reference/spatIDs-generic.html)
  and
  [`featIDs()`](https://giotto-suite.github.io/GiottoClass/reference/spatIDs-generic.html)
  generics
- New
  [`objName()`](https://giotto-suite.github.io/GiottoClass/reference/giotto_schema.html)
  and `objName` generics for setting the names of relevant S4 subobjects
- New [`rbind()`](https://rdrr.io/r/base/cbind.html) generic to append
  `giottoPolygon` objects
- Add packages `exactextractr` and `sf` to “suggests” packages
- Add package `progressr` to “imports” packages

### Changes

- Move giotto object method\*specific creation functions from `giotto.R`
  to `convenience.R`
- Update
  [`addFeatMetadata()`](https://giotto-suite.github.io/GiottoClass/reference/addFeatMetadata.html)
  to handle replacement of existing columns
- Update [`show()`](https://rdrr.io/r/methods/show.html) method for
  `giotto`
- Update [`show()`](https://rdrr.io/r/methods/show.html) method for
  `spatEnrObj`
- Deprecate older snake_case accessors
- Deprecate `polygon_feat_names` param in favor of `z_indices` in
  [`readPolygonFilesVizgenHDF5()`](https://giottosuite.com/dev/reference/readPolygonFilesVizgenHDF5.md)
- Deprecate `xy_translate_spatial_locations()` in favor of
  `shift_spatial_locations()`
- Optimize
  [`readPolygonFilesVizgen()`](https://giottosuite.com/dev/reference/readPolygonFilesVizgen.md)
- Fix bug in
  [`replaceGiottoInstructions()`](https://giotto-suite.github.io/GiottoClass/reference/replaceGiottoInstructions.html)
  where instructions with more slots than previous are not allowed
- Fix bug in
  [`loadGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/loadGiotto.html)
  that prevents proper parsing of filenames when spat_unit or feat_type
  contains ’\_’ characters
- Fix
  [`loadGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/loadGiotto.html)
  loss of over*allocation for data.tables*based objects after loading
  from disk

## Giotto 3.1.0 (2022/12/01)

### Added

- New [`initialize()`](https://rdrr.io/r/methods/new.html) generic that
  calls
  [`setalloccol()`](https://rdrr.io/pkg/data.table/man/truelength.html)
  for data.table\*based S4 subobjects to allow setting by reference
- New `spatUnit`, `spatUnit<*`, `featType`, and `featType<*` feat type
  generics for S4 subobjects for setting the relevant slots
- Add
  [`hexVertices()`](https://giotto-suite.github.io/GiottoClass/reference/hexVertices.html)
  to polygon shape array generation functionality

### Changes

- Update
  [`createGiottoCosMxObject()`](https://giottosuite.com/dev/reference/createGiottoCosMxObject.md)
  for 3.0 and modularization of functions. ‘subcellular’ workflow has
  been tested to work along with an updated tutorial.
- Update grid plotting behavior to set a default number columns to use
  based on number of elements to plot. Can be overridden by explicitly
  providing input to `cow_n_col` param
- Fix bug in
  [`annotateGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/annotateGiotto.html)
  after 3.0 update
  ([\#433](https://github.com/drieslab/Giotto/issues/433#issuecomment*1324211224))
- Fix bug in
  [`joinGiottoObjects()`](https://giotto-suite.github.io/GiottoClass/reference/joinGiottoObjects.html)
  metadata processing
- Update seed setting behavior in
  [dimension_reduction.R](https://github.com/drieslab/Giotto/blob/suite/R/dimension_reduction.R)
  and
  [clustering.R](https://github.com/drieslab/Giotto/blob/suite/R/clustering.R)

## Giotto 3.0.1 (2022/11/20)

### Added

- New system color support detection (based on crayon package logic)
- Add ability to turn off colored text in `show` functions with
  `options("giotto.color_show" = FALSE)`

### Changes

- Fix bug in `extract_polygon_list()`
  ([\#433](https://github.com/drieslab/Giotto/issues/433#issuecomment*1321221382))
- Update Unicode character printing with `show` functions for Latin1
  systems

## Giotto 3.0.0 (2022/11/18)

### Breaking changes

- S4 subobjects framework will require giotto objects to be remade

### Added

- New
  [`createGiottoXeniumObject()`](https://giottosuite.com/dev/reference/createGiottoXeniumObject.md)
  for loading 10x Xenium data
- New S4 subobjects. Details can be found in
  [classes.R](https://github.com/drieslab/Giotto/blob/suite/R/classes.R)
- New basic generics for S4 subobjects. Mainly the use of `[]` and
  `[]<*` to get or set information into the main data slot
- New `@provenance` slot in S4 subobjects to track provenance of
  aggregated information (z_layers used for example)
- New
  [`calculateOverlapPolygonImages()`](https://giotto-suite.github.io/GiottoClass/reference/calculateOverlapPolygonImages.html)
  for calculating overlapped intensities from image\*based information
  (e.g. IMC, IF, MIBI, …) and polygon data (e.g. cell)
- New
  [`overlapImagesToMatrix()`](https://giotto-suite.github.io/GiottoClass/reference/overlapImagesToMatrix.html)
  converts intensity\*polygon overlap info into an expression matrix
  (e.g. cell by protein)
- New `aggregateStacks()` set of functions work with multiple
  subcellular layers when generating aggregated expression matrices

### Changes

- Update `setter` functions to read the `@spat_unit` and `@feat_type`
  slots of subobjects to determine nesting
- Update of `show` functions to display color coded nesting names and
  tree structure

## Giotto 2.1.0 (2022/11/09)

### Breaking changes

- Update of python version to **3.10.2**
  [details](https://giottosuite.readthedocs.io/en/latest/additionalinformation.html#giotto*suite*2*1*0*2202*11*09)

### Added

- New
  [`anndataToGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/anndataToGiotto.html)
  to convert scanpy anndata to Giotto

## Giotto 2.0.0.998

### Added

- New `GiottoData` package to work with spatial datasets associated with
  Giotto
  - Stores the minidatasets: preprocessed giotto objects that are ready
    to be used in any function
  - Moved:
    [`getSpatialDataset()`](https://giotto-suite.github.io/GiottoData/reference/getSpatialDataset.html)
    and
    [`loadGiottoMini()`](https://giotto-suite.github.io/GiottoData/reference/loadGiottoMini.html)
    functions to this package
- New
  [`saveGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/saveGiotto.html)
  and
  [`loadGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/loadGiotto.html)
  for preserving memory\*pointer based objects. In
  [general_help.R](https://github.com/drieslab/Giotto/blob/suite/R/general_help.R)
  - It saves a Giotto object into a folder using a specific structure.
    Essentially a wrapper around
    [`saveRDS()`](https://rdrr.io/r/base/readRDS.html) that also works
    with spatVector and spatRaster pointers.
- New `plotInteractivePolygon()` for plot\*interactive polygonal
  selection of points.
- New polygon shape array creation through
  [`polyStamp()`](https://giotto-suite.github.io/GiottoClass/reference/polyStamp.html),
  `circleVertices`, `rectVertices`. In
  [giotto_structures.R](https://github.com/drieslab/Giotto/blob/suite/R/giotto_structures.R)
- Add accessor functions `get_CellMetadata` (alias of
  [`pDataDT()`](https://giotto-suite.github.io/GiottoClass/reference/pDataDT.html)),
  `set_CellMetadata`, `get_FeatMetadata` (alias of
  [`fDataDT()`](https://giotto-suite.github.io/GiottoClass/reference/fDataDT.html)),
  `set_FeatMetadata`. See
  [accessors.R](https://github.com/drieslab/Giotto/blob/suite/R/accessors.R)
- New
  [`filterDistributions()`](https://giottosuite.com/dev/reference/filterDistributions.md)
  to generate histogram plots from expression statistics

### Changes

- Deprecate `plotInteractionChangedGenes()` ,`plotICG()`, `plotCPG()` in
  favor of `plotInteractionChangedFeatures()` and
  [`plotICF()`](https://giottosuite.com/dev/reference/plotICF.md) and
  [`plotCPF()`](https://giottosuite.com/dev/reference/plotCPF.md)
- Deprecate `plotCellProximityGenes()`, in favor of
  `plotCellProximityFeatures()`
- Deprecate `plotCombineInteractionChangedGenes()`, `plotCombineICG()`,
  `plotCombineCPG()` in favor of
  `plotCombineInteractionChangedFeatures()` and
  [`plotCombineICF()`](https://giottosuite.com/dev/reference/plotCombineICF.md)
- Deprecate
  [`findInteractionChangedGenes()`](https://giottosuite.com/dev/reference/findInteractionChangedGenes.md),
  [`findICG()`](https://giottosuite.com/dev/reference/findICG.md),
  [`findCPG()`](https://giottosuite.com/dev/reference/findCPG.md) in
  favor of
  [`findInteractionChangedFeats()`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)
  and `findICF`
- Deprecate
  [`filterInteractionChangedGenes()`](https://giottosuite.com/dev/reference/filterInteractionChangedGenes.md),
  [`filterICG()`](https://giottosuite.com/dev/reference/filterICG.md),
  [`filterCPG()`](https://giottosuite.com/dev/reference/filterCPG.md) in
  favor of
  [`filterInteractionChangedFeats()`](https://giottosuite.com/dev/reference/filterInteractionChangedFeats.md)
  and
  [`filterICF()`](https://giottosuite.com/dev/reference/filterInteractionChangedFeats.md)
- Deprecate
  [`combineInteractionChangedGenes()`](https://giottosuite.com/dev/reference/combineInteractionChangedGenes.md),
  [`combineICG()`](https://giottosuite.com/dev/reference/combineICG.md),
  [`combineCPG()`](https://giottosuite.com/dev/reference/combineCPG.md)
  in favor of
  [`combineInteractionChangedFeats()`](https://giottosuite.com/dev/reference/combineInteractionChangedFeats.md)
  and
  [`combineICF()`](https://giottosuite.com/dev/reference/combineInteractionChangedFeats.md)
- Deprecate `combineCellProximityGenes_per_interaction()` in favor of
  `combineCellProximityFeatures_per_interaction()`

### Breaking changes

- ICF output internal object structure names have changed to use feats
  instead of genes
