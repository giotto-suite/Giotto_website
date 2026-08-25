# cellProximityEnrichmentEachSpot

Compute cell-cell interaction enrichment for each spot with its
interacted spots (observed)

## Usage

``` r
cellProximityEnrichmentEachSpot(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  spatial_network_name = "spatial_network",
  cluster_column = "cell_ID"
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. 'cell')

- feat_type:

  feature type (e.g. 'rna')

- spatial_network_name:

  name of spatial network to use

- cluster_column:

  name of column to use for clusters

## Value

matrix that rownames are cell-cell interaction pairs and colnames are
cell_IDs

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
x <- findMarkers_one_vs_all(g,
    cluster_column = "leiden_clus", min_feats = 20
)
sign_gene <- x$feats

sign_matrix <- matrix(rnorm(length(sign_gene) * 8, mean = 10),
    nrow = length(sign_gene)
)
rownames(sign_matrix) <- sign_gene
colnames(sign_matrix) <- paste0("celltype_", unique(x$cluster))

g <- runDWLSDeconv(gobject = g, sign_matrix = sign_matrix)

cellProximityEnrichmentEachSpot(gobject = g)
```
