# clusterSpatialCorFeats

Cluster based on spatially correlated features

## Usage

``` r
clusterSpatialCorFeats(
  spatCorObject,
  name = "spat_clus",
  hclust_method = "ward.D",
  k = 10,
  return_obj = TRUE
)
```

## Arguments

- spatCorObject:

  spatial correlation object

- name:

  name for spatial clustering results

- hclust_method:

  method for hierarchical clustering

- k:

  number of clusters to extract

- return_obj:

  return spatial correlation object (spatCorObject)

## Value

spatCorObject or cluster results

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

clusterSpatialCorFeats(spatCorObject = detectSpatialCorFeats(
    g,
    method = "network"
))
```
