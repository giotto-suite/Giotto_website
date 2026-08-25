# findICFSpot

Identifies cell-to-cell Interaction Changed Features (ICF) for spots,
i.e. features expression residual that are different due to proximity to
other cell types. Works using results from celltype deconvolution
methods such as those from
[`runDWLSDeconv()`](https://giottosuite.com/dev/reference/runDWLSDeconv.md).

## Usage

``` r
findICFSpot(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = c("normalized", "scaled", "custom"),
  ave_celltype_exp,
  selected_features = NULL,
  spatial_network_name = "Delaunay_network",
  deconv_name = "DWLS",
  minimum_unique_cells = 5,
  minimum_unique_int_cells = 5,
  CCI_cell_score = 0.1,
  dwls_cutoff = 0.001,
  diff_test = "permutation",
  nr_permutations = 100,
  adjust_method = "fdr",
  do_parallel = TRUE,
  cores = NA,
  set_seed = TRUE,
  seed_number = 1234,
  verbose = FALSE
)
```

## Arguments

- gobject:

  A giotto object

- spat_unit:

  spatial unit (e.g. 'cell')

- feat_type:

  feature type (e.g. 'rna')

- expression_values:

  expression values to use

- ave_celltype_exp:

  `matrix` or `data.frame`. Average feature expression in each cell
  type. Colnames should be the cell type and rownames are feat names.

- selected_features:

  subset of selected features (optional)

- spatial_network_name:

  name of spatial network to use

- deconv_name:

  name of deconvolution/spatial enrichment values to use

- minimum_unique_cells:

  minimum number of target cells required

- minimum_unique_int_cells:

  minimum number of interacting cells required

- CCI_cell_score:

  cell proximity score to filter no interacted cell

- dwls_cutoff:

  cell type proportion cutoff to label the cell

- diff_test:

  which differential expression test

- nr_permutations:

  number of permutations if diff_test = permutation

- adjust_method:

  which method to adjust p-values

- do_parallel:

  run calculations in parallel with mclapply

- cores:

  number of cores to use if do_parallel = TRUE

- set_seed:

  set a seed for reproducibility

- seed_number:

  seed number

- verbose:

  be verbose

## Value

`icfObject` that contains the differential feat scores

## Details

Function to calculate if features expression residual are differentially
expressed in cell types when they interact (approximated by physical
proximity) with other cell types. Feature expression residual calculated
as: (observed expression in spot - cell_type_proportion \*
average_expressed_in_cell_type) The results data.table in the
`icfObject` contains - at least - the following columns:

- **features:** All or selected list of tested features

- **sel:** average feature expression residual in the interacting cells
  from the target cell type

- **other:** average feature expression residual in the NOT-interacting
  cells from the target cell type

- **pcc_sel:** correlation between cell proximity score and expression
  residual in the interacting cells from the target cell type

- **pcc_other:** correlation between cell proximity score and expression
  residual in the NOT-interacting cells from the target cell type

- **pcc_diff:** correlation difference between sel and other

- **p.value:** associated p-value

- **p.adj:** adjusted p-value

- **cell_type:** target cell type

- **int_cell_type:** interacting cell type

- **nr_select:** number of cells for selected target cell type

- **int_nr_select:** number of cells for interacting cell type

- **unif_int:** cell-cell interaction

## See also

[`findInteractionChangedFeats()`](https://giottosuite.com/dev/reference/findInteractionChangedFeats.md)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
x <- findMarkers_one_vs_all(g,
    cluster_column = "leiden_clus", min_feats = 20
)
sign_gene <- x$feats

sign_matrix <- matrix(rnorm(length(sign_gene) * 7, mean = 10),
    nrow = length(sign_gene)
)
rownames(sign_matrix) <- sign_gene
colnames(sign_matrix) <- paste0("celltype_", unique(x$cluster))

g <- runDWLSDeconv(gobject = g, sign_matrix = sign_matrix)
ave_celltype_exp <- calculateMetaTable(g, metadata_cols = "leiden_clus")
ave_celltype_exp <- data.table::dcast(
    ave_celltype_exp, variable ~ leiden_clus
)
ave_celltype_exp <- as.matrix(ave_celltype_exp, rownames = "variable")
colnames(ave_celltype_exp) <- colnames(sign_matrix)

res <- findICFSpot(g,
    spat_unit = "cell",
    feat_type = "rna",
    ave_celltype_exp = ave_celltype_exp,
    spatial_network_name = "spatial_network"
)
force(res)
```
