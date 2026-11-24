# Interoperability: AnnData

## 1 Converting to and from AnnData

This tutorial shows how to write a Giotto object as AnnData `.h5ad`
files with
[`giottoToAnnData()`](https://giotto-suite.github.io/GiottoClass/reference/giottoToAnnData.html)
and read them back with
[`anndataToGiotto()`](https://giotto-suite.github.io/GiottoConnect/reference/anndataToGiotto.html).
Both functions are part of
[GiottoConnect](https://github.com/giotto-suite/GiottoConnect) and read
and write `.h5ad` files directly from R: no python environment is
needed. The files use the layout scanpy and squidpy expect, so they can
be analysed there as well.

A mini Giotto object is used to keep the computational requirements low.

## 2 Start Giotto

``` r

# Ensure Giotto Suite, GiottoData and GiottoConnect are installed
if (!"Giotto" %in% installed.packages()) {
    pak::pkg_install("giotto-suite/Giotto")
}
if (!"GiottoData" %in% installed.packages()) {
    pak::pkg_install("giotto-suite/GiottoData")
}
if (!"GiottoConnect" %in% installed.packages()) {
    pak::pkg_install("giotto-suite/GiottoConnect")
}

library(Giotto)
library(GiottoData)
library(GiottoConnect)
```

## 3 Load a Giotto object

The vizgen mini object has three spatial units (`z0`, `z1` and
`aggregate`), each with the `rna` feature type.

``` r

results_folder <- "/path/to/results/"

g <- loadGiottoMini("vizgen")
```

Squidpy uses a kNN network by default, while Giotto’s default is an sNN.
We add two kNN networks next to the existing sNN to show that every
network is converted under its own name.

``` r

g <- createNearestNetwork(g,
    spat_unit = "aggregate",
    feat_type = "rna",
    type = "kNN",
    dim_reduction_to_use = "umap",
    dim_reduction_name = "umap",
    k = 15,
    name = "kNN.umap"
)

g <- createNearestNetwork(g,
    spat_unit = "aggregate",
    feat_type = "rna",
    type = "kNN",
    dim_reduction_to_use = "umap",
    dim_reduction_name = "umap",
    k = 6,
    name = "new_network"
)

list_nearest_networks(g, spat_unit = "aggregate")
```

``` r
   spat_unit feat_type nn_type        name
      <char>    <char>  <char>      <char>
1: aggregate       rna     sNN     sNN.pca
2: aggregate       rna     kNN    kNN.umap
3: aggregate       rna     kNN new_network
```

## 4 Giotto to AnnData

An AnnData object holds one table of cells by features, so each `.h5ad`
file holds one spatial unit and feature type of the Giotto object. By
default
[`giottoToAnnData()`](https://giotto-suite.github.io/GiottoClass/reference/giottoToAnnData.html)
writes the active ones; `spat_unit` and `feat_type` choose others. Here
we write one file per spatial unit.

``` r

for (su in c("z0", "z1", "aggregate")) {
    giottoToAnnData(g,
        file = file.path(results_folder, paste0(su, "_rna.h5ad")),
        spat_unit = su,
        feat_type = "rna"
    )
}
```

The parts of the Giotto object go to their usual AnnData places:

- normalized values in `X`, raw counts in `layers/counts`, and every
  other expression value (here `scaled` and `pearson`) as a layer of the
  same name;
- cell and feature metadata in `obs` and `var`;
- spatial locations in `obsm/spatial`, dimension reductions in
  `obsm/X_<name>` and the PCA loadings in `varm/PCs`;
- every nearest neighbour and spatial network in `obsp`
  (`<name>_distances` and `<name>_connectivities`) with a record of the
  same name in `uns`;
- the tissue image in `uns/spatial`.

``` r

anndataR::read_h5ad(file.path(results_folder, "aggregate_rna.h5ad"))
```

``` r
InMemoryAnnData object with n_obs × n_vars = 462 × 337
    obs: 'nr_feats', 'perc_feats', 'total_expr', 'leiden_clus', 'louvain_clus'
    var: 'nr_cells', 'perc_cells', 'total_expr', 'mean_expr', 'mean_expr_det', 'hvg_orig', 'var', 'hvf'
    uns: 'giottoConnect', 'kNN.umap', 'new_network', 'pca', 'sNN.pca', 'spatial', 'spatial_Delaunay_network', 'spatial_kNN_network'
    obsm: 'X_pca', 'X_tsne', 'X_umap', 'spatial'
    varm: 'PCs'
    layers: 'counts', 'pearson', 'scaled'
    obsp: 'kNN.umap_connectivities', 'kNN.umap_distances', 'new_network_connectivities', 'new_network_distances', 'sNN.pca_connectivities', 'sNN.pca_distances', 'spatial_Delaunay_network_connectivities', 'spatial_Delaunay_network_distances', 'spatial_kNN_network_connectivities', 'spatial_kNN_network_distances'
```

In scanpy, a network is used by its name, for example:

``` python
import scanpy as sc

adata = sc.read_h5ad("aggregate_rna.h5ad")
sc.tl.leiden(adata, neighbors_key = "kNN.umap")
```

[`readbackCheck()`](https://giotto-suite.github.io/GiottoConnect/reference/readbackCheck.html)
compares the written file with the Giotto object, part by part:

``` r

readbackCheck(g, file.path(results_folder, "aggregate_rna.h5ad"))
```

``` r
<giottoReadback> PASS: 44 MATCH, 0 DECLARED, 0 UNDECLARED
```

## 5 AnnData to Giotto

[`anndataToGiotto()`](https://giotto-suite.github.io/GiottoConnect/reference/anndataToGiotto.html)
reads an `.h5ad` file into a Giotto object. Files written by
[`giottoToAnnData()`](https://giotto-suite.github.io/GiottoClass/reference/giottoToAnnData.html)
come back with their networks, reductions and expression values under
the same names; files from scanpy or squidpy are read the same way.

``` r

aggregate_rna <- anndataToGiotto(file.path(results_folder, "aggregate_rna.h5ad"))

list_nearest_networks(aggregate_rna)
list_spatial_networks(aggregate_rna)
list_expression(aggregate_rna)
```

``` r
   spat_unit feat_type nn_type        name
      <char>    <char>  <char>      <char>
1:      cell       rna     kNN    kNN.umap
2:      cell       rna     kNN new_network
3:      cell       rna     sNN     sNN.pca

   spat_unit             name
      <char>           <char>
1:      cell Delaunay_network
2:      cell      kNN_network

   spat_unit feat_type       name
      <char>    <char>     <char>
1:      cell       rna        raw
2:      cell       rna normalized
3:      cell       rna    pearson
4:      cell       rna     scaled
```

Each file becomes a Giotto object with the spatial unit `cell` and the
feature type `rna`.

[`mappingProvenance()`](https://giotto-suite.github.io/GiottoConnect/reference/mappingProvenance.html)
shows how the file was converted, including anything that could not be
carried over or was estimated:

``` r

mappingProvenance(aggregate_rna)$losses
```

`anndataToGiotto(..., source = "my_project/")` builds a
GiottoDisk-backed object instead, for files that do not fit in memory.

## 6 Session Info

``` r

sessionInfo()
```

``` r
R version 4.5.3 (2026-03-11)
Platform: aarch64-apple-darwin20
Running under: macOS Tahoe 26.7.3

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/lib/libRblas.0.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1

locale:
[1] C.UTF-8/C.UTF-8/C.UTF-8/C/C.UTF-8/C.UTF-8

time zone: America/New_York
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] GiottoConnect_0.1.0 GiottoData_0.3.8    Giotto_4.3.7        GiottoClass_0.8.0  

loaded via a namespace (and not attached):
  [1] RColorBrewer_1.1-3          jsonlite_2.0.0              magrittr_2.0.5             
  [4] magick_2.9.1                farver_2.1.2                vctrs_0.7.3                
  [7] memoise_2.0.1               GiottoUtils_0.2.10          terra_1.9-11               
 [10] htmltools_0.5.9             S4Arrays_1.10.1             BiocNeighbors_2.4.0        
 [13] Rhdf5lib_1.32.0             rhdf5_2.54.1                SparseArray_1.10.9         
 [16] sctransform_0.4.3           parallelly_1.50.0           KernSmooth_2.23-26         
 [19] htmlwidgets_1.6.4           ica_1.0-3                   plyr_1.8.9                 
 [22] plotly_4.12.1               cachem_1.1.0                igraph_2.3.4               
 [25] lifecycle_1.0.5             pkgconfig_2.0.3             anndataR_1.0.2             
 [28] rsvd_1.0.5                  Matrix_1.7-5                R6_2.6.1                   
 [31] fastmap_1.2.0               MatrixGenerics_1.22.0       future_1.82.0              
 [34] digest_0.6.39               colorspace_2.1-4            patchwork_1.3.2            
 [37] S4Vectors_0.48.1            Seurat_6.0.0                RSpectra_0.16-2            
 [40] irlba_2.4.1                 GenomicRanges_1.62.1        beachmat_2.26.0            
 [43] progressr_0.18.0            httr_1.4.9                  polyclip_1.10-7            
 [46] abind_1.4-8                 compiler_4.5.3              proxy_0.4-29               
 [49] bit64_4.6.0-1               withr_3.0.3                 S7_1.0.0                   
 [52] backports_1.5.1             BiocParallel_1.44.0         DBI_1.3.0                  
 [55] viridis_0.6.5               fastDummies_1.7.6           ggforce_0.5.0              
 [58] MASS_7.3-65                 DelayedArray_0.36.0         classInt_0.4-11            
 [61] rjson_0.2.23                bluster_1.20.0              gtools_3.9.5               
 [64] units_1.0-1                 GiottoVisuals_0.2.16        tools_4.5.3                
 [67] otel_0.3.0                  future.apply_1.21.0         glue_1.8.1                 
 [70] dbscan_1.2.4                rhdf5filters_1.22.0         grid_4.5.3                 
 [73] sf_1.1-1                    checkmate_2.3.4             Rtsne_0.17                 
 [76] cluster_2.1.8.2             reshape2_1.4.5              generics_0.1.4             
 [79] hdf5r_1.3.12                gtable_0.3.6                class_7.3-23               
 [82] tidyr_1.3.2                 data.table_1.18.6.1         BiocSingular_1.26.1        
 [85] tidygraph_1.3.1             ScaledMatrix_1.18.0         sp_2.2-1                   
 [88] XVector_0.50.0              BiocGenerics_0.56.0         tilework_1.0.0             
 [91] RcppAnnoy_0.0.23            ggrepel_0.9.8               RANN_2.6.2                 
 [94] pillar_1.11.1               stringr_1.6.0               spam_2.11-3                
 [97] RcppHNSW_0.6.0              dplyr_1.2.1                 tweenr_2.0.3               
[100] lattice_0.22-9              bit_4.6.0                   tidyselect_1.2.1           
[103] SingleCellExperiment_1.32.0 pbapply_1.7-5               gridExtra_2.3.1            
[106] IRanges_2.44.0              Seqinfo_1.0.0               SummarizedExperiment_1.40.0
[109] scattermore_1.2             stats4_4.5.3                pls_2.9-0                  
[112] graphlayouts_1.2.3          Biobase_2.70.0              matrixStats_1.5.0          
[115] stringi_1.8.9               yaml_2.3.12                 codetools_0.2-20           
[118] ggraph_2.2.2                tibble_3.3.1                colorRamp2_0.1.0           
[121] cli_3.6.6                   uwot_0.2.4                  reticulate_1.47.0          
[124] dichromat_2.0-0.1           Rcpp_1.1.2                  globals_0.20.0             
[127] png_0.1-9                   parallel_4.5.3              ggplot2_4.0.4              
[130] dotCall64_1.2               listenv_1.1.0               SpatialExperiment_1.20.0   
[133] viridisLite_0.4.3           e1071_1.7-17                scales_1.4.0               
[136] ggridges_0.5.7              SeuratObject_5.4.0          purrr_1.2.2                
[139] rlang_1.3.0                 cowplot_1.2.0
```
