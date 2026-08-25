# rankSpatialCorGroups

Rank spatial correlated clusters according to correlation structure

## Usage

``` r
rankSpatialCorGroups(
  gobject,
  spatCorObject,
  use_clus_name = NULL,
  show_plot = NULL,
  return_plot = FALSE,
  save_plot = NULL,
  save_param = list(),
  default_save_name = "rankSpatialCorGroups"
)
```

## Arguments

- gobject:

  giotto object

- spatCorObject:

  spatial correlation object

- use_clus_name:

  name of clusters to visualize (from
  [`clusterSpatialCorFeats()`](https://giottosuite.com/dev/reference/clusterSpatialCorFeats.md))

- show_plot:

  logical. show plot

- return_plot:

  logical. return ggplot object

- save_plot:

  logical. directly save the plot

- save_param:

  list of saving parameters, see
  [`showSaveParameters`](https://giotto-suite.github.io/GiottoVisuals/reference/showSaveParameters.html)

- default_save_name:

  default save name for saving, don't change, change save_name in
  save_param

## Value

data.table with positive (within group) and negative (outside group)
scores

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

spatCorObject <- detectSpatialCorFeats(g, method = "network")
clusters <- clusterSpatialCorFeats(spatCorObject = spatCorObject)

rankSpatialCorGroups(
    gobject = g, spatCorObject = clusters,
    use_clus_name = "spat_clus"
)
```
