# cellProximityEnrichment

Compute cell-cell interaction enrichment (observed vs expected)

## Usage

``` r
cellProximityEnrichment(
  gobject,
  spat_unit = NULL,
  feat_type = NULL,
  spatial_network_name = "Delaunay_network",
  cluster_column,
  number_of_simulations = 1000,
  adjust_method = c("none", "fdr", "bonferroni", "BH", "holm", "hochberg", "hommel",
    "BY"),
  set_seed = TRUE,
  seed_number = 1234
)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit

- feat_type:

  feature type

- spatial_network_name:

  name of spatial network to use

- cluster_column:

  name of column to use for clusters

- number_of_simulations:

  number of simulations to create expected observations

- adjust_method:

  method to adjust p.values

- set_seed:

  use of seed

- seed_number:

  seed number to use

## Value

List of cell Proximity scores (CPscores) in data.table format. The first
data.table (raw_sim_table) shows the raw observations of both the
original and simulated networks. The second data.table (enrichm_res)
shows the enrichment results.

## Details

Spatial proximity enrichment or depletion between pairs of cell types is
calculated from the observed over the expected frequency of cell-cell
proximity interactions. The expected frequency is the average frequency
across \`number_of_simulations\` spatial network simulations. Each
simulation reshuffles the cell type labels over the nodes (cells) of the
spatial network, holding the network topology fixed; every cell
therefore carries a single label across all of its edges.

Empirical p-values use the unbiased estimator \`(1 + \#simulated \>=
observed) / (1 + number_of_simulations)\`, so they lie in \`(0, 1\]\`
and can never be exactly zero.

Alongside the enrichment score \`enrichm\`, the result carries the
standard deviation of the simulated counts (\`sd_sim\`) and a
standardized effect size (\`z\`).

The result is only as good as the network it is given. On a large
section pass \`delaunay_method = "delaunayn_geometry"\` to
\[GiottoClass::createSpatialNetwork()\] – an identical triangulation,
orders of magnitude faster – and set \`maximum_distance_delaunay\`
explicitly, so that edges spanning empty tissue are not counted as
proximity. See the \*Building the network for a large section\* section
of \[cellProximityMotifs()\].

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

cellProximityEnrichment(g, cluster_column = "leiden_clus")
```
