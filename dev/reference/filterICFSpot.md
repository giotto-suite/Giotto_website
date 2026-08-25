# filterICFSpot

Filter Interaction Changed Feature scores for spots.

## Usage

``` r
filterICFSpot(
  icfObject,
  min_cells = 4,
  min_cells_expr_resi = 0.05,
  min_int_cells = 4,
  min_int_cells_expr_resi = 0.05,
  min_fdr = 0.5,
  min_pcc_diff = 0.05,
  min_zscore = 0.05,
  zscores_column = c("cell_type", "features"),
  direction = c("both", "up", "down")
)
```

## Arguments

- icfObject:

  ICF (interaction changed feature) score object

- min_cells:

  minimum number of source cell type

- min_cells_expr_resi:

  minimum expression residual level for source cell type

- min_int_cells:

  minimum number of interacting neighbor cell type

- min_int_cells_expr_resi:

  minimum expression residual level for interacting neighbor cell type

- min_fdr:

  minimum adjusted p-value

- min_pcc_diff:

  minimum absolute pcc difference difference

- min_zscore:

  minimum z-score change

- zscores_column:

  calculate z-scores over cell types or features

- direction:

  differential expression directions to keep

## Value

icfObject that contains the filtered differential feature scores

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")
icfObject <- findInteractionChangedFeats(g, cluster_column = "leiden_clus")

filterICFSpot(icfObject = icfObject)
```
