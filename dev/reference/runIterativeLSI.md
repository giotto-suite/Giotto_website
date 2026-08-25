# Run Iterative Latent Semantic Indexing (LSI)

Performs Iterative LSI on a Giotto object, replicating ArchR's approach
using Giotto functions.

## Usage

``` r
runIterativeLSI(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression_values = "raw",
  name = NULL,
  feats_to_use = NULL,
  return_gobject = TRUE,
  iterations = 2,
  sample_cells_pre = 10000,
  sample_cells_final = NULL,
  var_features = 25000,
  dims = 1:30,
  scale_to = 10000,
  lsi_method = 2,
  resolution = 2,
  first_selection = "top",
  k = 10,
  seed = 1234,
  set_seed = TRUE,
  cor_cutoff = 0.75,
  verbose = NULL
)
```

## Arguments

- gobject:

  Giotto object

- spat_unit:

  Spatial unit (e.g., "cell")

- feat_type:

  Feature type (e.g., "spatial_atac")

- expression_values:

  Values to use (e.g., "raw")

- name:

  Name for reduction (default: feat_type + "\_iterative_lsi")

- feats_to_use:

  Initial feature subset (NULL = all)

- return_gobject:

  Return Giotto object (default = TRUE)

- iterations:

  Number of iterations (default = 2)

- sample_cells_pre:

  Cells to subsample in early iterations

- sample_cells_final:

  Cells to subsample in final iteration (NULL = all)

- var_features:

  Number of variable features (default = 25000)

- dims:

  Vector of LSI dimensions to use for clustering and projection steps
  (default = 1:30)

- scale_to:

  TF-IDF scaling factor for sub_method 2 (default = 10000)

- lsi_method:

  TF-IDF method: 1 = Casanovich, 2 = Stuart, 3 = ArchR, 4 = Giotto
  (default = 3). See \[Giotto::norm_tfidf\] for more information on how
  each of these are calculated.

- resolution:

  Clustering resolution (default = 2)

- first_selection:

  "top" (accessibility) or "var" (variance) (default = "var")

- k:

  Number of nearest neighbors for sNN (default = 10)

- seed:

  Seed for reproducibility (default = 1234)

- set_seed:

  Logical, whether to set a seed (default = TRUE)

- cor_cutoff:

  Correlation cutoff for filtering LSI dimensions correlated with
  sequencing depth in intermediate steps (default = 0.75)

- verbose:

  Verbosity (default = NULL, inherits from gobject)

## Value

Giotto object or LSI coordinates
