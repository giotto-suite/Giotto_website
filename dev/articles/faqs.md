# Frequently Asked Questions

For troubleshooting help, see this
[page](https://giottosuite.com/dev/articles/troubleshooting.md)

## Installation

- [How do I install an R package for the first
  time?](https://giottosuite.com/dev/articles/installation.md)
- [Can I install Python components
  manually?](https://giottosuite.com/dev/articles/configuration.md)

## Usage

- [What does a Giotto workflow look
  like?](https://giottosuite.com/dev/articles/general_workflow.md)
- [How do I create a Giotto analysis
  object?](https://giottosuite.com/dev/articles/object_creation.md)
- [Is there low-level tooling for importing from popular spatial
  technologies?](https://giottosuite.com/dev/articles/import_utilities.md)
- [What are Giotto
  instructions?](https://giottosuite.com/dev/articles/instructions.md)
- [How do I calculate a raw expression matrix from raw features and
  segementations?](https://giottosuite.com/dev/articles/feature_aggregation.md)
- [How do I set up spatial bins to aggregate
  with?](https://giottosuite.com/dev/articles/tesslation.md)
- [Is there a convenient workflow function for data
  processing?](https://giottosuite.com/dev/articles/process_giotto.md)
- [How can I build a composable pipeline for processing my
  data?](https://giottosuite.com/dev/articles/normalization.md)
- [What are spatial units and feature
  types?](https://giottosuite.com/dev/articles/object_creation.md)
- [What are important Giotto functions to
  know?](https://giottosuite.com/dev/articles/core_functions.md)
- [How do I spatially manipulate my
  data?](https://giottosuite.com/dev/articles/spatial_transformations.md)
- [How do I extract data out of the Giotto
  Object?](https://giottosuite.com/dev/articles/getters_setters.md)
- [How do I interactively select my
  data?](https://giottosuite.com/dev/articles/interactive_selection.md)
- [What is the structure of the Giotto
  Object?](https://giottosuite.com/dev/articles/structure.md)
- [How do I register spatial datasets
  together?](https://giottosuite.com/dev/articles/affine_registration.md)
- [Are there any tools for TMA
  data?](https://giottosuite.com/dev/articles/tma.md)
- [How do I perform data
  filtering?](https://giottosuite.com/dev/articles/filtering.md)
- [How do I set up a spatial or nearest neighbor
  network?](https://giottosuite.com/dev/articles/networks.md)
- [How do I find variable
  features?](https://giottosuite.com/dev/articles/hvf.md)
- [How do I perform dimension
  reduction?](https://giottosuite.com/dev/articles/dimension_reduction.md)
- [How can I detect spatially organized
  genes?](https://giottosuite.com/dev/articles/spatial_genes.md)
- [How do I cluster features into modules with similar spatial
  expression
  patterns?](https://giottosuite.com/dev/articles/spatial_coexpression_modules.md)
- [How can I check for enrichment of gene/feature
  signatures?](https://giottosuite.com/dev/articles/page_rank_enrichment.md)
- [The biology I study is highly spatially organized. Can I improve my
  clustering?](https://giottosuite.com/dev/articles/spatial_informed_clusters.md)
- [What can I find differentially expressed
  features?](https://giottosuite.com/dev/articles/find_degs.md)
- [How do I use Harmony with Giotto to remove batch
  effects?](https://giottosuite.com/dev/articles/harmony.md)
- [How do I use HMRF?](https://giottosuite.com/dev/articles/hmrf.md)
- [How do I deconvolve my
  data?](https://giottosuite.com/dev/articles/deconvolution.md)
- [How do I perform kriging to super-resolve my Visium
  data?](https://giottosuite.com/dev/articles/kriging.md)
- [How do I save my
  object?](https://giottosuite.com/dev/articles/saving_object.md)
- [How do I save/export my
  plots?](https://giottosuite.com/dev/articles/saving_plots.md)
- [Is there a docker
  image?](https://giottosuite.com/dev/articles/docker.md)
- [Can I use the docker image with
  singularity?](https://giottosuite.com/dev/articles/singularity.md)
- [How do I contribute to
  Giotto?](https://giottosuite.com/dev/articles/creating_a_pull_request.md)
- [How do I report a
  bug?](https://giottosuite.com/dev/articles/github_issues.md)

## Data Availability

Where can I find seqFISH+ and other ready-to-use datasets?

- Checkout our [GiottoData](https://github.com/giotto-suite/GiottoData)
  extension package to find already preprocessed datasets and Giotto
  mini Objects.

Where else can I find more spatial datasets?

Checkout the following for more spatial-omics data:

- [Aquila](https://aquila.cheunglab.org/view)
- Tencent's [SODB](https://gene.ai.tencent.com/SpatialOmics/)
- [PySODB](https://pysodb.readthedocs.io/en/latest/), a python interface
  for the SODB

How can I automatically download tutorial datasets?

Use
[`getSpatialDataset()`](https://giotto-suite.github.io/GiottoData/reference/getSpatialDataset.html)
from GiottoData:

``` r

# Ensure Giotto Suite is installed
if(!"Giotto" %in% installed.packages()) {
  pak::pkg_install("giotto-suite/Giotto")
}

library(Giotto)

# Ensure Giotto Data is installed
if(!"GiottoData" %in% installed.packages()) {
  pak::pkg_install("giotto-suite/GiottoData")
}

library(GiottoData)


# choose your directory
my_working_dir = getwd()

# merFISH example:

# standard download data to working directory
getSpatialDataset(dataset = 'merfish_preoptic', 
                  directory = my_working_dir)

# use wget to  download data to working directory (much faster)
getSpatialDataset(dataset = 'merfish_preoptic', 
                  directory = my_working_dir, 
                  method = 'wget')

# avoid certification issues with wget
getSpatialDataset(dataset = 'merfish_preoptic', 
                  directory = my_working_dir, 
                  method = 'wget', 
                  extra = '--no-check-certificate')
```
