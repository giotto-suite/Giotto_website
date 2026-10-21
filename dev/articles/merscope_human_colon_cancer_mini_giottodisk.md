# Human colon cancer MERSCOPE mini dataset with GiottoDisk

## 1 The dataset

Vizgen MERSCOPE, human colon cancer, FFPE. A 408 x 411 um field from
region R1 of
`202502261437_HuColonCan-FFPE-D2M1883-V2-UltraSm-ST_VMSC18810` ([data
release](https://info.vizgen.com/merfish-2.0-data-release-form)). Panel:
815 gene targets, 85 `Blank` barcodes. 305,890 transcripts, 2,090
segmented cells.

| input file                     | size  | contents                          |
|--------------------------------|-------|-----------------------------------|
| `detected_transcripts.parquet` | 10 MB | transcript, x, y, z, cell         |
| `cell_boundaries.parquet`      | 1 MB  | polygons, seven z-planes per cell |

## 2 Packages

``` r

remotes::install_github(c(
    "giotto-suite/GiottoUtils@65fb1a9b",
    "giotto-suite/GiottoClass@b3e79326",
    "giotto-suite/GiottoVisuals@bec7b11b",
    "giotto-suite/Giotto@e611ed99",
    "drieslab/tilework@f4616fa3"))
remotes::install_local("path/to/GiottoDisk")   # branch feat/merscope-on-dev
BiocManager::install("scran")
```

## 3 Setup

``` r

suppressMessages({
  library(Giotto); library(GiottoClass); library(GiottoDisk)
  library(data.table); library(ggplot2); library(cowplot)
  library(Matrix); library(terra)
})

# MERSCOPE region directory (the folder containing detected_transcripts.parquet)
merscope_dir <- "data/region_R1"

th <- theme_classic(base_size = 9)
set.seed(42)

CLUS_COLS <- c("#2B5C9B", "#DD8452", "#3E8E57", "#C44E52", "#8172B3",
               "#7BA3D0", "#A0490D", "#DA8BC3", "#4C9F9F", "#5A5A5A",
               "#9E3D6B", "#1B7F79")
clus_palette <- function(x) {
    lev <- levels(factor(x))
    setNames(CLUS_COLS[seq_along(lev)], lev)
}
```

## 4 Ingest

First we set up a `gDirSource` object using `sourceCreate()` as a handle
for a Giotto file directory disk backend. A backend defines the storage
architecture and also associated preferred write formats for data types.
Currently, the only option available is a managed project directory via
`gDirSource`, but other solutions are planned. `sourceCreate()` creates
the project directory with an empty manifest, `giottodir.json`. Printing
`src` shows what the manifest records: saved objects (`giottosaves`) and
stored data (`artifacts`).

Next, using `setArtifactDumpDir()`, we point GiottoDisk writes of
content such as expression matrices and spatial information directly at
the backend.

``` r

# project directory for the on-disk data
src <- sourceCreate("giotto_project")
# intermediate results of later steps go to the project directory
setArtifactDumpDir(src)
src
```

    ## <gDirSource>
    ## giottosaves: 0 
    ## artifacts: 0

[`createGiottoMerscopeObject()`](https://giottosuite.com/dev/reference/createGiottoMerscopeObject.md)
creates a Giotto object from a MERSCOPE output directory. Passing the
`gDirSource` object to the `backend` param sets the object up as a
disk-backed project.

``` r

g <- createGiottoMerscopeObject(
    merscope_dir = merscope_dir,
    backend      = src)
instructions(g) <- createGiottoInstructions(
    save_plot = FALSE, show_plot = TRUE, return_plot = FALSE)
g
```

    ## An object of class giotto 
    ## >Active spat_unit:  cell 
    ## >Active feat_type:  rna 
    ## dimensions    : 815, 2090 (features, cells)
    ## [SUBCELLULAR INFO]
    ## polygons      : cell 
    ## features      : rna neg_probe 
    ## [AGGREGATE INFO]
    ## expression -----------------------
    ##   [cell][rna] raw
    ##   [cell][neg_probe] raw
    ## spatial locations ----------------
    ##   [cell] raw
    ## 
    ## 
    ## Use objHistory() to see steps and params used

Setting `backend` builds the object on disk: transcripts stream into a
quadtree of parquet tiles and polygons into a parquet geometry store.
The negative controls go into their own `[cell][neg_probe]` layer. The
cell x gene layer is read from `cell_by_gene.csv`, and the vendor
`cell_id` column is kept on the transcripts. No overlap between
transcripts and polygons is calculated. The y coordinates are negated on
load, so plots have the orientation of the Vizgen images.

``` r

g <- addStatistics(g, expression_values = "raw")
saveGiotto(g, name = "aggregated", overwrite = TRUE)
```

``` r

cells <- as.data.table(pDataDT(g))
feats <- as.data.table(fDataDT(g))
data.table(item  = c("cells", "gene targets", "median transcripts / cell",
                     "median genes / cell"),
           value = c(format(nrow(cells), big.mark = ","),
                     format(nrow(feats), big.mark = ","),
                     median(cells$total_expr), median(cells$nr_feats)))
```

| item                      | value |
|:--------------------------|------:|
| cells                     | 2,090 |
| gene targets              |   815 |
| median transcripts / cell |    84 |
| median genes / cell       |    58 |

## 5 Quality control and filtering

**QC plots**

``` r

spatInSituPlotPoints(g, show_polygon = TRUE, polygon_fill = "total_expr",
                     polygon_fill_as_factor = FALSE,
                     polygon_fill_gradient_style = "sequential",
                     polygon_color = "black", polygon_line_size = 0.08,
                     background_color = "white")
```

![](images/merscope_human_colon_cancer_mini_giottodisk/01_qc-spatial.png)

``` r

# transcripts per cell
p_tx <- filterDistributions(g, method = "sum", detection = "cells",
                            scale_axis = "log10", nr_bins = 90,
                            show_plot = FALSE, return_plot = TRUE) +
    labs(title = NULL, x = "transcripts per cell", y = "cells") + th

# genes detected per cell, with the detection floor
p_genes <- filterDistributions(g, method = "threshold", detection = "cells",
                               nr_bins = 90,
                               show_plot = FALSE, return_plot = TRUE) +
    geom_vline(xintercept = 15, color = "#C44E52", linetype = "dashed") +
    labs(title = NULL, x = "genes detected per cell", y = "cells") + th

# cells per gene
p_cells <- filterDistributions(g, method = "threshold", detection = "feats",
                               scale_axis = "log10", nr_bins = 90,
                               show_plot = FALSE, return_plot = TRUE) +
    labs(title = NULL, x = "cells per gene", y = "genes") + th

plot_grid(p_tx, p_genes, p_cells, nrow = 1)
```

![](images/merscope_human_colon_cancer_mini_giottodisk/02_qc-histograms.png)

``` r

cells <- as.data.table(pDataDT(g))
g <- addCellMetadata(g, new_metadata = data.table(
         cell_ID = cells$cell_ID,
         qc_fail = ifelse(cells$nr_feats < 15, "removed", "kept")),
     by_column = TRUE, column_cell_ID = "cell_ID")
spatInSituPlotPoints(g, show_polygon = TRUE, polygon_fill = "qc_fail",
                     polygon_fill_as_factor = TRUE,
                     polygon_fill_code = c(kept = "#B9C6D6", removed = "#C44E52"),
                     polygon_color = "black", polygon_line_size = 0.08,
                     background_color = "white")
```

![](images/merscope_human_colon_cancer_mini_giottodisk/03_qc-flag.png)

Raising `min_det_feats_per_cell` discards more poorly segmented and
low-signal cells at the cost of losing real cells with sparse
expression; lowering it keeps those cells but admits fragments and
near-empty polygons into the clustering.

``` r

g <- filterGiotto(g, expression_threshold = 1, feat_det_in_min_cells = 10,
                  min_det_feats_per_cell = 15, verbose = TRUE)
```

    ## 
    ## Feature type:  rna 
    ## Number of cells removed:  157  out of  2090 
    ## Number of feats removed:  65  out of  815

## 6 Normalization and dimension reduction

Normalization puts cells on a comparable scale so that differences in
total counts per cell, which track cell size and detection efficiency,
do not dominate the distances used for clustering.

``` r

g <- normalizeGiotto(g, norm_methods = "standard", scale_feats = FALSE,
                     scale_cells = FALSE)
g <- addStatistics(g, expression_values = "normalized")
g <- runPCA(g, expression_values = "normalized", ncp = 100)
```

``` r

screePlot(g, ncp = 30)
```

![](images/merscope_human_colon_cancer_mini_giottodisk/04_scree.png)

## 7 Neighbors, UMAP, clustering

``` r

g <- createNearestNetwork(g, dim_reduction_to_use = "pca",
                          dimensions_to_use = 2:15, k = 30, type = "sNN",
                          minimum_shared = 5, engine = "hnsw")
g <- doLeidenCluster(g, resolution = 0.25, n_iterations = 100)
g <- runUMAP(g, dim_reduction_to_use = "pca", dimensions_to_use = 2:15,
             n_neighbors = 30, min_dist = 0.01)
```

``` r

PAL_CLUS <- clus_palette(pDataDT(g)$leiden_clus)
plotUMAP(g, cell_color = "leiden_clus", cell_color_code = PAL_CLUS, point_size = 1.2,
         point_shape = "no_border")
```

![](images/merscope_human_colon_cancer_mini_giottodisk/05_clusters-umap.png)

## 8 Markers

``` r

mk <- findMarkers_one_vs_all(g, method = "scran", expression_values = "normalized",
                             cluster_column = "leiden_clus", min_feats = 3)
setorder(mk, cluster, ranking)
top <- mk[, .(top_genes = paste(head(feats, 6), collapse = ", ")), by = cluster]
top[]
```

    ## start with cluster  1start with cluster  2start with cluster  3start with cluster  4start with cluster  5

**Top marker genes per cluster**

| cluster | top_genes                                 |
|--------:|:------------------------------------------|
|       1 | MYC, RNF43, SOX9, ERBB3, EPCAM, HMGA1     |
|       2 | FYN, ZAP70, CD2, IL2RB, PIK3CD, TRAC      |
|       3 | CD74, CIITA, ITGB2, CSF1R, CMKLR1, ICAM1  |
|       4 | COL5A1, COL4A1, FOS, PDGFRB, DUSP1, SOCS3 |
|       5 | MZB1, XBP1, IRF4, DERL3, PRDM1, POU2AF1   |

``` r

sel <- unique(mk[, head(feats, 3), by = cluster]$V1)
dotPlot(g, feats = sel, cluster_column = "leiden_clus")
```

![](images/merscope_human_colon_cancer_mini_giottodisk/06_dotplot.png)

## 9 Cell types

Each Leiden cluster is named from its top markers in section 8.

``` r

g <- annotateGiotto(g,
    annotation_vector = c("1" = "Epithelial", "2" = "T/NK", "3" = "Myeloid",
                          "4" = "Fibroblast", "5" = "B/Plasma"),
    cluster_column = "leiden_clus", name = "cell_type")
cells <- as.data.table(pDataDT(g))
PAL <- clus_palette(cells$cell_type)
```

``` r

ct <- cells[, .(cells = .N), by = .(cell_type)]
ct[, pct := round(100 * cells / sum(cells), 1)][order(-cells)]
```

| cell_type  | cells |  pct |
|:-----------|------:|-----:|
| Epithelial |  1495 | 77.3 |
| Fibroblast |   187 |  9.7 |
| B/Plasma   |   103 |  5.3 |
| T/NK       |    86 |  4.4 |
| Myeloid    |    62 |  3.2 |

``` r

setorder(ct, -cells); ct[, cell_type := factor(cell_type, levels = rev(cell_type))]
ggplot(ct, aes(cell_type, cells, fill = cell_type)) +
    geom_col(width = 0.75) +
    scale_fill_manual(values = PAL, guide = "none") +
    coord_flip() +
    geom_text(aes(label = formatC(cells, big.mark = ",", format = "d")),
              hjust = -0.1, size = 2.6) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.22))) +
    labs(x = NULL, y = "cells") + th
```

![](images/merscope_human_colon_cancer_mini_giottodisk/07_cells-per-type.png)

``` r

saveGiotto(g, name = "clustered", overwrite = TRUE)
```

## 10 The slide

``` r

# segmentation polygons filled by cell type
p_facets <- spatInSituPlotPoints(g, show_polygon = TRUE, polygon_fill = "cell_type",
                                 polygon_fill_as_factor = TRUE, polygon_fill_code = PAL,
                                 polygon_color = "black", polygon_line_size = 0.05,
                                 background_color = "white",
                                 show_legend = FALSE, show_plot = FALSE, return_plot = TRUE)

# all cells in gray behind every panel
bgv <- p_facets$layers[[1]]$data[, .(x, y, poly_ID)]
p_facets$layers <- c(geom_polygon(data = bgv, aes(x, y, group = poly_ID),
                                  fill = "#E8E8E8", color = NA, inherit.aes = FALSE),
                     p_facets$layers)

# one panel per cell type
p_facets + facet_wrap(~cell_type, ncol = 3) +
    theme(strip.background = element_blank(),
          strip.text = element_text(size = 13, face = "bold"),
          panel.spacing = unit(10, "pt"))
```

![](images/merscope_human_colon_cancer_mini_giottodisk/08_spatial-facets.png)

## 11 Cell boundaries

``` r

# segmentation polygons filled by cell type
p_types <- spatInSituPlotPoints(g, show_polygon = TRUE, polygon_fill = "cell_type",
                                polygon_fill_as_factor = TRUE, polygon_fill_code = PAL,
                                polygon_color = "black", polygon_line_size = 0.12,
                                background_color = "white",
                                show_plot = FALSE, return_plot = TRUE)

# one marker gene per cell type
MARKERS <- c("Epithelial" = "EPCAM", "T/NK" = "TRAC", "Myeloid" = "CD74",
             "Fibroblast" = "PDGFRB", "B/Plasma" = "MZB1")
p_markers <- spatInSituPlotPoints(g, feats = list(rna = unname(MARKERS)),
                                  feats_color_code = setNames(PAL[names(MARKERS)], MARKERS),
                                  point_size = 0.6, use_overlap = FALSE, show_polygon = TRUE,
                                  polygon_bg_color = "white", polygon_color = "black",
                                  polygon_line_size = 0.12, plot_last = "points",
                                  background_color = "white",
                                  show_plot = FALSE, return_plot = TRUE)

plot_grid(p_types, p_markers, nrow = 1)
```

![](images/merscope_human_colon_cancer_mini_giottodisk/09_polygons.png)

## 12 Spatial neighborhood composition

Each cell is linked to its twenty nearest neighbors.
[`cellProximityEnrichment()`](https://giottosuite.com/dev/reference/cellProximityEnrichment.md)
counts the links between each pair of cell types and compares the counts
with 1,000 random relabelings of the cells, so a log2 enrichment above 0
means the pairing is more common than chance. The clustering used no
spatial information, so this tests whether the expression-defined
populations are spatially organized.

``` r

g <- createSpatialNetwork(g, method = "kNN", k = 20, name = "kNN20")
cpe <- cellProximityEnrichment(g, cluster_column = "cell_type",
                               spatial_network_name = "kNN20",
                               number_of_simulations = 1000)
head(cpe$enrichm_res[type_int == "hetero"][order(-enrichm)], 8)[
    , .(pair = unified_int, enrichment = round(enrichm, 2), p.adj_higher)]
```

| pair                  | enrichment | p.adj_higher |
|:----------------------|-----------:|-------------:|
| Myeloid–T/NK          |       1.54 |     0.000999 |
| B/Plasma–T/NK         |       1.34 |     0.000999 |
| B/Plasma–Fibroblast   |       0.88 |     0.000999 |
| B/Plasma–Myeloid      |       0.73 |     0.000999 |
| Fibroblast–T/NK       |       0.71 |     0.000999 |
| Fibroblast–Myeloid    |       0.69 |     0.000999 |
| Epithelial–Fibroblast |      -0.48 |     1.000000 |
| Epithelial–T/NK       |      -0.61 |     1.000000 |

``` r

cellProximityHeatmap(g, CPscore = cpe, order_cell_types = TRUE, scale = FALSE)
```

![](images/merscope_human_colon_cancer_mini_giottodisk/10_neighbour-heatmap.png)

## 13 Session

``` r

sessionInfo()
```

    ## R version 4.5.2 (2025-10-31)
    ## Platform: aarch64-apple-darwin20
    ## Running under: macOS 27.0.1
    ## 
    ## Matrix products: default
    ## BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1
    ## 
    ## locale:
    ## [1] en_US/en_US/en_US/C/en_US/en_US
    ## 
    ## time zone: America/New_York
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] future_1.76.0       terra_1.9-50        Matrix_1.7-4       
    ## [4] cowplot_1.2.0       ggplot2_4.0.3       data.table_1.18.6.1
    ## [7] GiottoDisk_0.0.0.6  Giotto_4.3.5        GiottoClass_0.7.18 
    ## 
    ## loaded via a namespace (and not attached):
    ##   [1] RColorBrewer_1.1-3          shape_1.4.6.1              
    ##   [3] jsonlite_2.0.0              wk_0.9.5                   
    ##   [5] magrittr_2.0.5              farver_2.1.2               
    ##   [7] rmarkdown_2.32              GlobalOptions_0.1.4        
    ##   [9] vctrs_0.7.3                 memoise_2.0.1              
    ##  [11] GiottoUtils_0.2.7           htmltools_0.5.9            
    ##  [13] S4Arrays_1.10.1             BiocNeighbors_2.4.0        
    ##  [15] SparseArray_1.10.10         sass_0.4.10                
    ##  [17] parallelly_1.48.0           bslib_0.12.0               
    ##  [19] htmlwidgets_1.6.4           plotly_4.12.1              
    ##  [21] cachem_1.1.0                igraph_2.3.3               
    ##  [23] lifecycle_1.0.5             iterators_1.0.14           
    ##  [25] pkgconfig_2.0.3             rsvd_1.0.5                 
    ##  [27] R6_2.6.1                    fastmap_1.2.0              
    ##  [29] clue_0.3-68                 MatrixGenerics_1.22.0      
    ##  [31] digest_0.6.39               colorspace_2.1-3           
    ##  [33] S4Vectors_0.48.1            dqrng_0.4.1                
    ##  [35] RSpectra_0.16-2             irlba_2.3.7                
    ##  [37] GenomicRanges_1.62.1        beachmat_2.26.0            
    ##  [39] filelock_1.0.3              labeling_0.4.3             
    ##  [41] progressr_1.0.0             httr_1.4.9                 
    ##  [43] polyclip_1.10-7             abind_1.4-8                
    ##  [45] compiler_4.5.2              bit64_4.8.6                
    ##  [47] withr_3.0.3                 doParallel_1.0.17          
    ##  [49] S7_0.2.2                    backports_1.5.1            
    ##  [51] BiocParallel_1.44.0         viridis_0.6.5              
    ##  [53] ggforce_0.5.0               R.utils_2.13.0             
    ##  [55] MASS_7.3-65                 DelayedArray_0.36.1        
    ##  [57] rjson_0.2.23                bluster_1.20.0             
    ##  [59] gtools_3.9.5                GiottoVisuals_0.2.16       
    ##  [61] tools_4.5.2                 otel_0.2.0                 
    ##  [63] future.apply_1.20.2         R.oo_1.27.1                
    ##  [65] glue_1.8.1                  dbscan_1.2.6               
    ##  [67] grid_4.5.2                  checkmate_2.3.4            
    ##  [69] cluster_2.1.8.1             generics_0.1.4             
    ##  [71] gtable_0.3.6                R.methodsS3_1.8.2          
    ##  [73] tidyr_1.3.2                 BiocSingular_1.26.1        
    ##  [75] tidygraph_1.3.1             ScaledMatrix_1.18.0        
    ##  [77] metapod_1.18.0              XVector_0.50.0             
    ##  [79] BiocGenerics_0.56.0         tilework_1.0.0             
    ##  [81] ggrepel_0.9.8               foreach_1.5.2              
    ##  [83] pillar_1.11.1               RcppHNSW_0.7.0             
    ##  [85] limma_3.66.0                circlize_0.4.18            
    ##  [87] dplyr_1.2.1                 tweenr_2.0.3               
    ##  [89] lattice_0.22-7              bit_4.6.0                  
    ##  [91] tidyselect_1.2.1            ComplexHeatmap_2.26.1      
    ##  [93] SingleCellExperiment_1.32.0 locfit_1.5-9.12            
    ##  [95] scuttle_1.20.0              knitr_1.52                 
    ##  [97] gridExtra_2.3.1             IRanges_2.44.0             
    ##  [99] Seqinfo_1.0.0               edgeR_4.8.2                
    ## [101] SummarizedExperiment_1.40.0 scattermore_1.2            
    ## [103] stats4_4.5.2                xfun_0.61                  
    ## [105] graphlayouts_1.2.5          Biobase_2.70.0             
    ## [107] statmod_1.5.2               matrixStats_1.5.0          
    ## [109] yaml_2.3.12                 evaluate_1.0.5             
    ## [111] codetools_0.2-20            ggraph_2.2.2               
    ## [113] tibble_3.3.1                colorRamp2_0.1.1           
    ## [115] cli_3.6.6                   uwot_0.2.5                 
    ## [117] arrow_25.0.1                jquerylib_0.1.4            
    ## [119] Rcpp_1.1.2                  globals_0.19.1             
    ## [121] png_0.1-9                   parallel_4.5.2             
    ## [123] assertthat_0.2.1            scran_1.38.1               
    ## [125] listenv_1.0.0               viridisLite_0.4.3          
    ## [127] scales_1.4.0                crayon_1.5.3               
    ## [129] purrr_1.2.2                 GetoptLong_1.1.1           
    ## [131] rlang_1.3.0

NA \`\`\`
