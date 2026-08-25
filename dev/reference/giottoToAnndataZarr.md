# Create a local anndata zarr folder

Create a local anndata zarr folder

## Usage

``` r
giottoToAnndataZarr(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  expression = "raw",
  pca_name = NULL,
  umap_name = NULL,
  tsne_name = NULL,
  output_path
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. "cell")

- feat_type:

  feature type (e.g. "rna", "dna", "protein")

- expression:

  expression values to extract (e.g. "raw", "normalized", "scaled")

- pca_name:

  optional. Default = NULL. Provide the pca name in your Giotto object.
  If a pca exists and a name is not provided, the function will use
  "pca" or the first available pca name.

- umap_name:

  optional. Default = NULL. Provide the umap name in your Giotto object.
  If a umap exists and a name is not provided, the function will use
  "umap" or the first available umap name.

- tsne_name:

  optional. Default = NULL. Provide the tsne name in your Giotto object.
  If a tsne exists and a name is not provided, the function will use
  "tsne" or the first available tsne name.

- output_path:

  path to create and save the anndata zarr folder

## Value

local anndata zarr folder

## Examples

``` r
# using the mini visium object
giotto_object <- GiottoData::loadGiottoMini("visium")

giottoToAnndataZarr(giotto_object,
    expression = "raw",
    output_path = tempdir()
)

# using the mini vizgen object
giotto_object <- GiottoData::loadGiottoMini("vizgen")

giottoToAnndataZarr(giotto_object,
    spat_unit = "aggregate",
    expression = "scaled",
    output_path = tempdir()
)
```
