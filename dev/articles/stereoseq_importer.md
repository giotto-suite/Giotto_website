# Stereo-seq Data Import

## 1 Introduction

Stereo-seq (Spatiotemporal Enhanced REsolution Omics-sequencing)
captures gene expression at near-single-cell resolution across a tissue
section. After processing with the STOmics pipeline, your data lands in
an `outs/` folder containing GEF files (gene expression matrices),
images, and cell segmentation polygons.

This tutorial walks through every way Giotto can read Stereo-seq data —
from quick bin-level loading to full piecewise control — so you can
choose the approach that fits your analysis.

## 2 Set up Giotto environment

Ensure that the Giotto package is installed. If you have installation
troubles, visit the
[Installation](https://giotto-suite.github.io/Giotto_website/articles/installation.html)
and [Frequently Asked
Questions](https://giotto-suite.github.io/Giotto_website/articles/faqs.html)
sections.

``` r

# Ensure Giotto Suite is installed.
if(!"Giotto" %in% installed.packages()) {
  pak::pkg_install("giotto-suite/Giotto")
}

library(Giotto)
```

------------------------------------------------------------------------

## 3 The `outs/` Directory

After running the STOmics Cell-bin pipeline you will find the following
layout:

    outs/
    ├── feature_expression/
    │   ├── tissue.gef              # bin expression — tissue-filtered (default)
    │   ├── <sample>.gef            # bin expression — full capture array
    │   ├── raw.gef                 # raw bin expression (rarely needed)
    │   ├── cellbin.gef             # cell-level expression (raw segmentation)
    │   └── adjusted_cellbin.gef   # cell-level expression (refined segmentation)
    └── image/
        ├── HE_regist.tif           # H&E image registered to expression coords
        ├── HE_mask.tif             # binary cell mask (used as polygon source)
        └── HE_tissue_cut.tif       # tissue boundary mask

``` r

# Set the path to your Stereo-seq outs/ directory
data_dir <- "/path/to/outs"
```

### 3.1 GEF files

GEF (Gene Expression Format) is an HDF5-based file that stores a sparse
expression matrix together with spatial coordinates.

| File | What it contains | When to use |
|----|----|----|
| `tissue.gef` | Bin-aggregated, tissue-filtered | **Default** for bin analysis |
| `<sample>.gef` (full) | Bin-aggregated, entire capture array | QC or background comparison |
| `adjusted_cellbin.gef` | Cell-level, refined segmentation | **Default** for cell analysis |
| `cellbin.gef` | Cell-level, raw segmentation | When you need the un-adjusted calls |

**Bins** aggregate the raw 0.5 µm DNB spots into square grids: `bin100`
groups 100 × 100 DNBs into one spot (~50 µm), comparable in size to a
10x Visium spot. Smaller bin sizes (e.g. `bin50`, `bin20`) give higher
resolution at the cost of sparser expression per spot.

### 3.2 Polygon sources

There are two ways to get cell boundary polygons in Giotto:

- **cellBorder** — polygon vertices embedded directly in the GEF file.
  Very fast to load (~0.1 s). Available via `load_polygons = TRUE`.
- **HE mask** — polygons derived from `HE_mask.tif` by tracing the
  binary mask. Slightly slower (~6 s) but often more detailed. Available
  via `load_mask = TRUE`.

Both sources produce the same `giottoPolygon` object and are
interchangeable for downstream analysis.

------------------------------------------------------------------------

## 4 Bin Aggregation

Use bin aggregation when you want a quick overview of gene expression
across the tissue, or when you do not have (or do not need) single-cell
resolution.

### 4.1 Loading a bin100 object

The simplest starting point is
[`createGiottoStereoSeqObjectBin()`](https://giottosuite.com/dev/reference/createGiottoStereoSeqObjectBin.md).
By default it reads `tissue.gef` (tissue-filtered) at the bin size you
specify.

``` r

g_bin <- createGiottoStereoSeqObjectBin(
  stereoseq_dir = data_dir,
  bin_size      = "bin100",
  gef_type      = "tissue",   # default: tissue-filtered
  load_image    = TRUE,
  load_mask     = TRUE        # also load HE mask polygons
)
print(g_bin)
```

The result is a `giotto` object with:

- **expression** — sparse matrix of genes × bins under spatial unit
  `"bin100"`
- **spatial locations** — centroid coordinates for each bin
- **polygons** — HE mask polygon outlines (when `load_mask = TRUE`)
- **image** — registered H&E image

### 4.2 Tissue-filtered vs full array

The default `gef_type = "tissue"` includes only bins that overlap the
detected tissue. If you need the full capture array (e.g. for background
QC), set `gef_type = "full"`:

``` r

g_bin_full <- createGiottoStereoSeqObjectBin(
  stereoseq_dir = data_dir,
  bin_size      = "bin100",
  gef_type      = "full"
)
print(g_bin_full)
```

> **Note:** The full GEF can be considerably larger (15–20× more bins)
> and takes more memory. Use it only when you need the off-tissue
> background.

### 4.3 Visualising bin positions

Use
[`spatPlot2D()`](https://giotto-suite.github.io/GiottoVisuals/reference/spatPlot.html)
to overlay bin centroid positions on the H&E image and confirm they sit
on tissue:

``` r

spatPlot2D(
  gobject    = g_bin,
  spat_unit  = "bin100",
  show_image = TRUE,
  image_name = "image",
  point_size  = 2,
  point_alpha = 0.6
)
```

### 4.4 Other bin sizes

Any bin size available in your GEF file is accepted. Common options are
`"bin20"`, `"bin50"`, `"bin100"`, `"bin200"`. Smaller bins give higher
spatial resolution but sparser expression per spot:

``` r

g_bin50 <- createGiottoStereoSeqObjectBin(
  stereoseq_dir = data_dir,
  bin_size      = "bin50"
)
```

------------------------------------------------------------------------

## 5 Cell Aggregation

Cell aggregation uses pre-computed cell segmentation from the STOmics
pipeline (`adjusted_cellbin.gef` by default). Each observation is one
segmented cell rather than a fixed-size bin.

### 5.1 cellBorder polygons (fast)

The GEF file embeds polygon vertices for every cell (called
“cellBorder”). Loading them is nearly instant:

``` r

g_cell <- createGiottoStereoSeqObjectCell(
  stereoseq_dir = data_dir,
  gef_type      = "adjusted_cellbin",  # default
  load_image    = TRUE,
  load_polygons = TRUE,   # cellBorder polygons from the GEF file
  load_mask     = FALSE
)
print(g_cell)
```

Visualize cell centroids on the H&E image:

``` r

spatPlot2D(
  gobject    = g_cell,
  spat_unit  = "cell",
  show_image = TRUE,
  image_name = "image",
  point_size  = 1,
  point_alpha = 0.5
)
```

Overlay the cellBorder polygon outlines to verify they align with cell
boundaries in the H&E:

``` r

spatInSituPlotPoints(
  gobject           = g_cell,
  show_image        = TRUE,
  image_name        = "image",
  show_polygon      = TRUE,
  polygon_feat_type = "cell",
  polygon_color     = "white",
  polygon_alpha     = 0,
  polygon_line_size = 0.3,
  feats             = NULL,
  spat_unit         = "cell",
  point_size        = 0
)
```

### 5.2 HE mask polygons (more detailed)

As an alternative to cellBorder polygons, Giotto can derive polygons by
tracing the binary `HE_mask.tif`. These are often more accurate for
irregularly shaped cells:

``` r

g_cell_mask <- createGiottoStereoSeqObjectCell(
  stereoseq_dir = data_dir,
  gef_type      = "adjusted_cellbin",
  load_image    = TRUE,
  load_polygons = FALSE,
  load_mask     = TRUE    # polygons from HE_mask.tif (~6 s)
)
print(g_cell_mask)
```

``` r

spatInSituPlotPoints(
  gobject           = g_cell_mask,
  show_image        = TRUE,
  image_name        = "image",
  show_polygon      = TRUE,
  polygon_feat_type = "cell",
  polygon_color     = "white",
  polygon_alpha     = 0,
  polygon_line_size = 0.3,
  feats             = NULL,
  spat_unit         = "cell",
  point_size        = 0
)
```

**Note:** Use `load_polygons = TRUE` (cellBorder) for speed. Switch to
`load_mask = TRUE` if you need the most precise boundaries for your
downstream analysis.

------------------------------------------------------------------------

## 6 Bin1 with Custom Aggregation

The finest available resolution is `bin1` — individual 0.5 µm DNB spots,
one row per detected transcript. This is the raw data before any binning
or cell segmentation.

Use this approach when:

- You have your own cell segmentation (from Cellpose, Baysor, StarDist,
  etc.)
- You want to experiment with different aggregation polygons without
  re-loading the data
- You need single-molecule positional accuracy

Giotto stores bin1 transcript positions in a `giottoBinPoints` object,
then uses polygon overlap to produce a per-cell expression matrix.

### 6.1 Step 1 — Load bin1 data and mask polygons

``` r

g_bin1 <- createGiottoStereoSeqObjectBin(
  stereoseq_dir  = data_dir,
  bin_size       = "bin1",
  load_binpoints = TRUE,   # giottoBinPoints: DNB-level feature positions
  load_image     = TRUE,
  load_mask      = TRUE    # cell polygons to aggregate into
)
print(g_bin1)
```

The object now contains:

- `bin1` spatial unit — expression matrix and locations at DNB
  resolution
- `giottoBinPoints` — compact representation of all transcript positions
  (genes × positions)
- `cell` polygons — from the HE mask

### 6.2 Step 2 — Assign transcripts to polygons

[`calculateOverlap()`](https://giotto-suite.github.io/GiottoClass/reference/calculateOverlap.html)
determines which polygon each DNB falls into:

``` r

g_bin1 <- calculateOverlap(
  g_bin1,
  spat_info = "cell",
  feat_info = "rna"
)
```

### 6.3 Step 3 — Build a per-cell expression matrix

[`overlapToMatrix()`](https://giotto-suite.github.io/GiottoClass/reference/overlapToMatrix.html)
aggregates the overlapping DNBs into a genes × cells count matrix:

``` r

g_bin1 <- overlapToMatrix(
  g_bin1,
  spat_info = "cell",
  feat_info = "rna",
  name      = "raw"
)
print(g_bin1)
```

After this step the object has two spatial units:

- `bin1` — the original DNB-resolution data (5 million+ observations)
- `cell` — the new aggregated matrix (one column per polygon)

### 6.4 Visualise — DNB transcripts inside polygons

The zoomed plot below shows individual DNBs coloured by gene falling
inside cell polygon outlines:

``` r

selected_feats <- featIDs(g_bin1)[1:50]

spatInSituPlotPoints(
  gobject           = g_bin1,
  show_image        = TRUE,
  image_name        = "image",
  show_polygon      = TRUE,
  polygon_feat_type = "cell",
  polygon_color     = "white",
  polygon_alpha     = 0,
  polygon_line_size = 0.5,
  feats             = list(rna = selected_feats),
  use_overlap       = FALSE,
  spat_unit         = "bin1",
  point_size        = 0.4,
  expand_counts     = TRUE,
  count_info_column = "count",
  xlim              = c(5000, 6000),
  ylim              = c(-8000, -7000)
)
```

------------------------------------------------------------------------

## 7 Piecewise Loading with `importStereoSeq()`

For full control over which components are loaded and how they are
assembled, use the low-level
[`importStereoSeq()`](https://giottosuite.com/dev/reference/importStereoSeq.md)
reader. This is useful when:

- You only need a subset of components (e.g. expression + locations, no
  image)
- You want to load data at one bin size but switch to another later
- You are building a custom workflow that assembles the object from
  multiple sources

[`importStereoSeq()`](https://giottosuite.com/dev/reference/importStereoSeq.md)
returns a reader object with individual `$load_*()` functions — nothing
is read until you call them.

### 7.1 Create a reader

``` r

reader <- importStereoSeq(
  stereoseq_dir = data_dir,
  type          = "cell",
  gef_type      = "adjusted_cellbin"
)
print(reader)
```

### 7.2 Load components individually

Call only the loaders you need:

``` r

expr <- reader$load_expression()   # sparse expression matrix
sl   <- reader$load_spatlocs()     # spatial locations (cell centroids)
img  <- reader$load_image()        # registered H&E (giottoLargeImage)
poly <- reader$load_polygons()     # cellBorder polygons
mask <- reader$load_mask()         # HE mask polygons
gbp  <- reader$load_binpoints()   # bin1 transcript positions (giottoBinPoints)
```

### 7.3 Assemble a custom giotto object

Use
[`setGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/setGiotto.html)
to place each component into an empty object:

``` r

g_custom <- giotto()
g_custom <- setGiotto(g_custom, expr)
g_custom <- setGiotto(g_custom, sl)
g_custom <- setGiotto(g_custom, poly)  # choose cellBorder or mask, not both
g_custom <- setGiotto(g_custom, img)
print(g_custom)
```

Visualize the result to confirm everything is aligned:

``` r

spatPlot2D(
  gobject    = g_custom,
  spat_unit  = "cell",
  show_image = TRUE,
  image_name = "image",
  point_size  = 1,
  point_alpha = 0.5
)
```

### 7.4 Switch bin size on the fly

Create a second reader for a different bin size without re-specifying
all paths:

``` r

reader_bin50 <- importStereoSeq(data_dir, type = "bin", bin_size = "bin50")
expr_bin50   <- reader_bin50$load_expression()
```

------------------------------------------------------------------------

## 8 Summary: Which approach to use?

| Approach | Function | When to use |
|----|----|----|
| **Bin aggregation** | [`createGiottoStereoSeqObjectBin()`](https://giottosuite.com/dev/reference/createGiottoStereoSeqObjectBin.md) | Fast overview; no single-cell resolution needed |
| **Cell aggregation** | [`createGiottoStereoSeqObjectCell()`](https://giottosuite.com/dev/reference/createGiottoStereoSeqObjectCell.md) | Single-cell resolution; use pre-computed segmentation |
| **Bin1 + custom polygons** | `createGiottoStereoSeqObjectBin(bin_size = "bin1", load_binpoints = TRUE)` | Own segmentation; need maximum spatial precision |
| **Piecewise** | [`importStereoSeq()`](https://giottosuite.com/dev/reference/importStereoSeq.md) | Advanced; load only what you need, assemble manually |

For most users starting out,
[`createGiottoStereoSeqObjectCell()`](https://giottosuite.com/dev/reference/createGiottoStereoSeqObjectCell.md)
with `load_polygons = TRUE` (cellBorder) is the best default: it is
fast, produces single-cell resolution, and gives you polygon boundaries
out of the box.
