# screePlot

identify significant principal components (PCs) using an screeplot
(a.k.a. elbowplot)

## Usage

``` r
screePlot(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  dim_reduction_name = NULL,
  name = deprecated(),
  expression_values = c("normalized", "scaled", "custom"),
  reduction = c("cells", "feats"),
  method = c("irlba", "exact", "random", "factominer"),
  rev = FALSE,
  feats_to_use = NULL,
  center = FALSE,
  scale_unit = FALSE,
  ncp = 100,
  ylim = c(0, 20),
  verbose = TRUE,
  show_plot = NULL,
  return_plot = NULL,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "screePlot",
  ...
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- dim_reduction_name:

  name of PCA

- name:

  deprecated

- expression_values:

  expression values to use

- reduction:

  cells or features

- method:

  which implementation to use

- rev:

  do a reverse PCA

- feats_to_use:

  subset of features to use for PCA

- center:

  center data before PCA

- scale_unit:

  scale features before PCA

- ncp:

  numeric. max number of principal components to plot

- ylim:

  numeric. y-axis limits on scree plot

- verbose:

  be verbose

- show_plot:

  logical. show plot

- return_plot:

  logical. return ggplot object

- save_plot:

  logical. save the plot

- save_param:

  list of saving parameters, see
  [`showSaveParameters`](https://giotto-suite.github.io/GiottoVisuals/reference/showSaveParameters.html)

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

- ...:

  additional arguments to pca function, see
  [`runPCA`](https://giottosuite.com/dev/reference/runPCA.md)

## Value

ggplot object for scree method

## Details

Screeplot works by plotting the explained variance of each individual PC
in a barplot allowing you to identify which PC provides a significant
contribution (a.k.a 'elbow method').  
Screeplot will use an available pca object, based on the parameter
'name', or it will create it if it's not available (see
[`runPCA`](https://giottosuite.com/dev/reference/runPCA.md))

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

screePlot(g)
```
