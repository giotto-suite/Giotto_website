# Multiview spatial models of feature expression (MISTy)

Fits MISTy, the multiview model of Tanevski et al. (2022, *Genome
Biology* 23:97), on the cells of a Giotto object. For every target
feature it measures how much of the target's variation is explained by
the other features of the same cell (intraview), by the sum over the
cell's immediate neighbours (juxtaview), by a distance-weighted sum over
its wider neighbourhood (paraview) and, optionally, by the cell-type
composition of both neighbourhoods and by other feature types or
enrichment scores. It is the algorithm of the mistyR package
(`run_misty()` with `random_forest_model` or `linear_model`, then
`collect_results()`): the same view models, seeds, cross-validation,
meta-model, p-values and result tables, so mistyR's `plot_*()` functions
draw its output. One model is fitted on the whole slide, or one per
sample (e.g. per FOV) with `sample_by`.

It runs on all cells, also of whole slides and GiottoDisk-backed
objects: only the features used are read, cells are matched to their
positions by cell ID, neighbourhoods come from Giotto spatial networks
and every view is a sparse product (cost linear in the number of cells
and edges), and the meta-model's p-values are computed in closed form
(mistyR's `ridge::pvals()` forms an N x N matrix, which limits it to
about 20,000 cells).

## Usage

``` r
runMisty(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  targets = NULL,
  feats_to_use = NULL,
  spat_loc_name = NULL,
  coord_scale = 1,
  juxta_radius = 15,
  juxta_network = NULL,
  para_l = 20,
  para_family = c("gaussian", "exponential", "linear", "constant"),
  para_cutoff = NULL,
  para_zoi = 0,
  para_nn = NULL,
  para_network = NULL,
  composition = NULL,
  extra_views = NULL,
  sample_by = NULL,
  min_cells = 200L,
  model = c("random_forest", "linear"),
  bypass_intra = FALSE,
  cv_folds = 10L,
  num_trees = 100L,
  mtry = NULL,
  sample_fraction = NULL,
  cores = NA,
  seed = 42L,
  results_folder = NULL,
  name = "misty",
  view = NULL,
  return_gobject = TRUE,
  verbose = NULL
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type of the targets and of the intra-, juxta- and paraview

- expression_values:

  expression values of `feat_type` to model

- targets:

  features of `feat_type` to model. `NULL` (default): all of
  `feats_to_use`, or all features when both are `NULL`.

- feats_to_use:

  features of `feat_type` in the intraview, juxtaview and paraview, i.e.
  the predictors. Must include `targets`. `NULL` (default): `targets`.

- spat_loc_name:

  name of the spatial locations. `NULL`: the default.

- coord_scale:

  numeric \> 0. Factor that converts the spatial coordinates to the
  units of `juxta_radius`, `para_l`, `para_cutoff` and `para_zoi` (e.g.
  0.12028 for CosMx pixels to micrometres).

- juxta_radius:

  numeric or `NULL`. Juxtaview: sum over the Delaunay neighbours
  (`deldir`, as mistyR) no farther than this distance. `NULL`: no
  juxtaview.

- juxta_network:

  name of a stored spatial network of `spat_unit` to use for the
  juxtaview instead of a Delaunay network; its edges no longer than
  `juxta_radius` are kept.

- para_l:

  numeric (one or more) or `NULL`. Paraview: sum over the other cells
  weighted by `para_family` with length scale `para_l`, one paraview per
  value. `NULL`: no paraview.

- para_family:

  weight of a cell at distance d: `"gaussian"` `exp(-d^2 / l^2)`,
  `"exponential"` `exp(-d / l)`, `"linear"` `max(0, 1 - d / l)` or
  `"constant"` 1 (with `para_nn` nearest neighbours, `round(l)` when
  `para_nn` is `NULL`), as mistyR's `add_paraview()`.

- para_cutoff:

  numeric or `NULL`. Cells farther than `para_cutoff * para_l` are left
  out of the paraview (mistyR sums over all cells). `NULL`: 4 for
  `"gaussian"` and 16 for `"exponential"` (weights below 1.2e-7 are
  dropped), 1 for `"linear"` (exact).

- para_zoi:

  numeric. Zone of indifference: cells closer than this get weight 0 in
  the paraview (mistyR's `zoi`).

- para_nn:

  integer or `NULL`. Limit the paraview to the `para_nn` nearest
  neighbours of each cell (mistyR's `nn`).

- para_network:

  name of a stored spatial network of `spat_unit` to use for the
  paraview neighbours instead of building one. Weights come from the
  distances; a kNN network is used as directed.

- composition:

  `NULL` or a cell metadata column with a label per cell (e.g. cell
  types). Adds the juxtaview and paraview(s) of the one-hot labels: how
  many cells of each label are next to, or around, the cell.

- extra_views:

  `NULL` or a named list of further predictor sources. Each element is a
  list with either `feat_type` (+ optional `expression_values`, default
  `"normalized"`, and `feats`, default all; at most 500 features) or
  `enrichment` (the name of a spatial enrichment,

  - optional `feat_type`), and `views`, a subset of
    `c("intra", "juxta", "para")` (default `c("juxta", "para")`): the
    source's values in the cell itself, summed over the juxta
    neighbours, or weighted over the paraview.

- sample_by:

  `NULL` (default) or a cell metadata column (e.g. `"fov"`). `NULL` fits
  one model per target on all cells (the whole slide); a column fits one
  model per target in each of its groups (samples), on views built from
  the whole slide. See Details.

- min_cells:

  integer. With `sample_by`, samples with fewer cells (or fewer than
  `cv_folds`) are left out.

- model:

  view model: `"random_forest"` (ranger, mistyR's `random_forest_model`:
  100 trees, impurity importance, out-of-bag predictions) or `"linear"`
  (mistyR's `linear_model`: least squares, out-of-fold predictions,
  coefficients as importances).

- bypass_intra:

  logical. Leave the intraview out of the meta-model (mistyR's
  `bypass.intra`): the intraview model becomes a constant, so multi.R2
  is what the other views explain on their own.

- cv_folds:

  integer. Folds of the cross-validated performance estimate and of the
  linear view models' out-of-fold predictions.

- num_trees, mtry:

  random forest: number of trees and of features tried at each split
  (`NULL`: ranger's default, the square root of the number of
  predictors).

- sample_fraction:

  random forest: share of the cells drawn (with replacement) for each
  tree. `NULL` (default) draws as many cells as there are, as ranger and
  mistyR do; a smaller share such as 0.1 fits large data several times
  faster.

- cores:

  integer. Threads of each random forest. `NA`: Giotto's `giotto.cores`
  option. With a parallel `future` plan the targets (or, with
  `sample_by`, the samples) are instead fitted in parallel, one thread
  each; every worker loads the packages, so on one machine the threads
  usually match the workers' speed with less memory (per FOV on 146,000
  cells: 7.8 min and 6.2 GB with 4 threads, 8.5 min and 11.7 GB with 4
  workers).

- seed:

  integer. Seed of the random forests and the folds (mistyR's default
  42). The caller's random number state is restored on exit.

- results_folder:

  `NULL` or a folder to write mistyR's result files to
  (`coefficients.txt`, `performance.txt`, `importances_*.txt`), which
  `mistyR::collect_results()` reads. With `sample_by`, one subfolder per
  sample.

- name:

  prefix of the feature metadata columns

- view:

  character. Name of a
  [`GiottoClass::giottoView`](https://giotto-suite.github.io/GiottoClass/reference/giottoView.html)
  slotted on `gobject`. Supplied, the object is narrowed once before the
  expression, spatial locations, cell metadata and enrichments are read,
  so the model uses the view's cells.

- return_gobject:

  logical. Return the giotto object with the results in the feature
  metadata (default) or the result list.

- verbose:

  be verbose

## Value

With `return_gobject = TRUE`, the giotto object with `<name>_intra_R2`,
`<name>_multi_R2` and `<name>_gain_R2` (in %, the mean over the
cross-validation folds, and over the samples with `sample_by`) added to
the feature metadata of `feat_type` (`NA` for features that are not
targets). Otherwise a list shaped as `mistyR::collect_results()` returns
it (data.frames `improvements`, `contributions`, `importances`,
`improvements.stats`, `contributions.stats`, `importances.aggregated`),
which mistyR's `plot_improvement_stats()`, `plot_view_contributions()`,
`plot_interaction_heatmap()` and `plot_interaction_communities()` take.
Its `sample` column is the value of `sample_by`; for a whole-slide
model, the absolute path of `results_folder`, or `name`.

## Details

For each target and each view a model predicts the target from the
view's features: out-of-bag predictions for random forests, out-of-fold
predictions for linear models. Like mistyR, a view built from
`feats_to_use` (intra-, juxta- and paraview) leaves out the target's own
column; composition and extra views keep all their columns. The
meta-model regresses the target on the views' predictions: ordinary
least squares when it has one predictor, otherwise ridge regression with
the penalty chosen automatically (Cule and De Iorio 2012, as
`ridge::linearRidge()` with `lambda = "automatic"`, which mistyR uses).
Its coefficients are the view contributions, with p-values of a normal
test (ridge, as `ridge::pvals()`) or a t test (least squares).
Performance is estimated by `cv_folds`-fold cross-validation of the
meta-model (folds stratified by the target's quantiles, as
`caret::createFolds()`): intra.R2 is the R2 of the intraview alone,
multi.R2 that of all views, gain.R2 = multi.R2 - intra.R2 (in %;
negative fold values are set to 0, as mistyR does), with RMSE versions
and one-sided t tests of the gain (`p.R2`, `p.RMSE`). Importances are
standardised per target and view and weighted by 1 - p-value of the
view's contribution, as `collect_results()` does.

Whole slide or per sample: with `sample_by`, the views are built once
from the whole slide (a cell's neighbours across a sample border still
count) and the models are fitted on each sample's cells, as mistyR's
`run_misty()` on each sample followed by `collect_results()`. The
`*.stats` tables then hold means and standard deviations over the
samples, and `improvements` one row per sample, so the gains can be
mapped back onto the tissue. Per-sample models are MISTy's own design:
each learns the relationships within one region, so differences between
regions do not count as a neighbourhood effect, but each sees fewer
cells (lower intra.R2, noisier for rare targets). A target that is
constant in a sample is not fitted there.

Differences from mistyR: views are built from Giotto networks (Delaunay
by `deldir`, `dbscan` radius or kNN searches) on positions matched by
cell ID; the paraview is truncated at `para_cutoff * para_l`; the linear
view models use `cv_folds` folds (mistyR's `linear_model()` always uses
10); the result files of a run with only the intraview have one column
fewer than mistyR's. With the same views and settings the R2,
contributions and importances equal mistyR's.

Cost: views are sparse products, linear in the number of cells and edges
(about 130 edges per cell for a gaussian paraview with `para_l` = 20 um
at cell densities of tissue). The models hold the views as dense
matrices (cells x features of all views); a random forest with 100 trees
on 146,000 cells and 21 predictors takes about 11 s with 4 threads, so a
run costs about (targets x views) of those. Extra views are capped at
500 features each: select features (e.g. highly variable genes) or use
enrichment scores.

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
feats <- head(fDataDT(g)[order(-perc_cells), feat_ID], 10)

res <- runMisty(g, targets = feats[1:2], feats_to_use = feats,
    juxta_radius = 300, para_l = 300, model = "linear",
    return_gobject = FALSE)
res$improvements.stats
```
