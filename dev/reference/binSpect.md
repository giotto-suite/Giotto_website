# binSpect

Previously: `binGetSpatialGenes()`.  
BinSpect (Binary Spatial Extraction of genes) is a fast computational
method that identifies genes with a spatially coherent expression
pattern.  
There are several functions documented together here, mainly differing
in how to provide expression and spatial connectivity/networks
information. When data is in a `giotto` object, use `binSpect()` which
wraps `binSpectSingle()` and `binSpectMulti()`.

## Usage

``` r
binSpect(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  bin_method = c("kmeans", "rank"),
  expression_values = c("normalized", "scaled", "custom"),
  subset_feats = NULL,
  spatial_network_name = "Delaunay_network",
  spatial_network_k = NULL,
  reduce_network = FALSE,
  kmeans_algo = c("kmeans", "kmeans_arma", "kmeans_arma_subset"),
  nstart = 3,
  iter_max = 10,
  extreme_nr = 50,
  sample_nr = 50,
  percentage_rank = 30,
  do_fisher_test = TRUE,
  adjust_method = "fdr",
  calc_hub = FALSE,
  hub_min_int = 3,
  get_av_expr = TRUE,
  get_high_expr = TRUE,
  implementation = c("data.table", "simple", "matrix"),
  group_size = "automatic",
  do_parallel = TRUE,
  cores = NA,
  verbose = TRUE,
  knn_params = NULL,
  set.seed = deprecated(),
  seed = 1234,
  bin_matrix = NULL,
  summarize = c("p.value", "adj.p.value"),
  return_gobject = FALSE
)

binSpectSingleMatrix(
  expression_matrix,
  spatial_network = NULL,
  bin_matrix = NULL,
  bin_method = c("kmeans", "rank"),
  subset_feats = NULL,
  kmeans_algo = c("kmeans", "kmeans_arma", "kmeans_arma_subset"),
  nstart = 3,
  iter_max = 10,
  extreme_nr = 50,
  sample_nr = 50,
  percentage_rank = 30,
  do_fisher_test = TRUE,
  adjust_method = "fdr",
  calc_hub = FALSE,
  hub_min_int = 3,
  get_av_expr = TRUE,
  get_high_expr = TRUE,
  implementation = c("data.table", "simple", "matrix"),
  group_size = "automatic",
  do_parallel = TRUE,
  cores = NA,
  verbose = FALSE,
  set.seed = deprecated(),
  seed = 1234
)

binSpectSingle(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  bin_method = c("kmeans", "rank"),
  expression_values = c("normalized", "scaled", "custom"),
  subset_feats = NULL,
  spatial_network_name = "Delaunay_network",
  reduce_network = FALSE,
  kmeans_algo = c("kmeans", "kmeans_arma", "kmeans_arma_subset"),
  nstart = 3,
  iter_max = 10,
  extreme_nr = 50,
  sample_nr = 50,
  percentage_rank = 30,
  do_fisher_test = TRUE,
  adjust_method = "fdr",
  calc_hub = FALSE,
  hub_min_int = 3,
  get_av_expr = TRUE,
  get_high_expr = TRUE,
  implementation = c("data.table", "simple", "matrix"),
  group_size = "automatic",
  do_parallel = TRUE,
  cores = NA,
  verbose = TRUE,
  set.seed = deprecated(),
  seed = 1234,
  bin_matrix = NULL
)

binSpectMulti(
  gobject,
  feat_type = NULL,
  spat_unit = NULL,
  bin_method = c("kmeans", "rank"),
  expression_values = c("normalized", "scaled", "custom"),
  subset_feats = NULL,
  spatial_network_k = c(5, 10, 20),
  reduce_network = FALSE,
  kmeans_algo = c("kmeans", "kmeans_arma", "kmeans_arma_subset"),
  nstart = 3,
  iter_max = 10,
  extreme_nr = 50,
  sample_nr = 50,
  percentage_rank = c(10, 30),
  do_fisher_test = TRUE,
  adjust_method = "fdr",
  calc_hub = FALSE,
  hub_min_int = 3,
  get_av_expr = TRUE,
  get_high_expr = TRUE,
  implementation = c("data.table", "simple", "matrix"),
  group_size = "automatic",
  do_parallel = TRUE,
  cores = NA,
  verbose = TRUE,
  knn_params = NULL,
  set.seed = deprecated(),
  seed = 1234,
  summarize = c("adj.p.value", "p.value")
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- bin_method:

  method to binarize gene expression

- expression_values:

  expression values to use

- subset_feats:

  only select a subset of features to test

- spatial_network_name:

  name of spatial network to use (default = 'spatial_network')

- spatial_network_k:

  different k's for a spatial kNN to evaluate

- reduce_network:

  default uses the full network

- kmeans_algo:

  kmeans algorithm to use (kmeans, kmeans_arma, kmeans_arma_subset)

- nstart:

  kmeans: nstart parameter

- iter_max:

  kmeans: iter.max parameter

- extreme_nr:

  number of top and bottom cells (see details)

- sample_nr:

  total number of cells to sample (see details)

- percentage_rank:

  percentage of top cells for binarization

- do_fisher_test:

  perform fisher test

- adjust_method:

  p-value adjusted method to use (see
  [`p.adjust`](https://rdrr.io/r/stats/p.adjust.html))

- calc_hub:

  calculate the number of hub cells

- hub_min_int:

  minimum number of cell-cell interactions for a hub cell

- get_av_expr:

  calculate the average expression per gene of the high expressing cells

- get_high_expr:

  calculate the number of high expressing cells per gene

- implementation:

  enrichment implementation (data.table, simple, matrix)

- group_size:

  number of genes to process together with data.table implementation
  (default = automatic)

- do_parallel:

  run calculations in parallel with mclapply

- cores:

  number of cores to use if `do_parallel = TRUE`

- verbose:

  be verbose

- knn_params:

  list of parameters to create spatial kNN network

- set.seed:

  deprecated. Use `seed` param instead

- seed:

  seed for kmeans binarization. When `NULL`, no seed is set. Otherwise,
  accepts a numeric input that will be used as seed.

- bin_matrix:

  a binarized matrix, when provided it will skip the binarization
  process

- summarize:

  summarize the p-values or adjusted p-values

- return_gobject:

  whether to return values attached to the gobject or separately
  (default)

- expression_matrix:

  expression matrix

- spatial_network:

  spatial network in data.table format

## Value

data.table with results (see details)

## Details

We provide two ways to identify spatial genes based on gene expression
binarization. Both methods are identicial except for how binarization is
performed.

1.  **binarize:** Each gene is binarized (0 or 1) in each cell with
    **kmeans** (k = 2) or based on **rank** percentile

2.  **network:** All cells are connected through a spatial network based
    on the physical coordinates

3.  **contingency table:** A contingency table is calculated based on
    all edges of neighboring cells and the binarized expression (0-0,
    0-1, 1-0 or 1-1)

4.  For each gene an odds-ratio (OR) and fisher.test (optional) is
    calculated

Three different kmeans algorithms have been implemented:

1.  **kmeans:** default, see
    [`kmeans`](https://rdrr.io/r/stats/kmeans.html)

2.  **kmeans_arma:** from ClusterR, see `KMeans_arma`

3.  **kmeans_arma_subst:** from ClusterR, see `KMeans_arma`, but
    randomly subsets the vector for each gene to increase speed. Change
    extreme_nr and sample_nr for control.

Other statistics are provided (optional):

- Number of cells with high expression (binary = 1)

- Average expression of each gene within high expressing cells

- Number of hub cells, these are high expressing cells that have a user
  defined number of high expressing neighbors

By selecting a subset of likely spatial genes (e.g. soft thresholding
highly variable genes) can accelerate the speed. The simple
implementation is usually faster, but lacks the possibility to run in
parallel and to calculate hub cells.  
The data.table implementation might be more appropriate for large
datasets by setting the `group_size` (number of genes) parameter to
divide the workload.

## Functions

- `binSpectSingleMatrix()`: binSpect for a single spatial network and a
  provided expression matrix

- `binSpectSingle()`: binSpect for a single spatial network

- `binSpectMulti()`: binSpect for multiple spatial kNN networks

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

binSpect(g)

binSpectSingle(g)

g_expression <- getExpression(g, output = "matrix")
g_spat_net <- getSpatialNetwork(g, output = "networkDT")

binSpectSingleMatrix(
    expression_matrix = g_expression,
    spatial_network = g_spat_net
)
```
