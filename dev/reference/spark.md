# spark

Compute spatially expressed genes with SPARK method

## Usage

``` r
spark(
  gobject,
  spat_loc_name = "raw",
  feat_type = NULL,
  spat_unit = NULL,
  percentage = 0.1,
  min_count = 10,
  expression_values = "raw",
  num_core = 5,
  covariates = NULL,
  return_object = c("data.table", "spark"),
  ...
)
```

## Arguments

- gobject:

  giotto object

- spat_loc_name:

  name for spatial locations

- feat_type:

  feature type

- spat_unit:

  spatial unit

- percentage:

  The percentage of cells that are expressed for analysis

- min_count:

  minimum number of counts for a gene to be included

- expression_values:

  type of values to use (raw by default)

- num_core:

  number of cores to use

- covariates:

  The covariates in experiments, i.e. confounding factors/batch effect.
  Column name of giotto cell metadata.

- return_object:

  type of result to return (data.table or spark object)

- ...:

  Additional parameters to the `spark.vc` function

## Value

data.table with SPARK spatial genes results or the SPARK object

## Details

This function is a wrapper for the method implemented in the SPARK
package: SPARK package:

1.  **CreateSPARKObject** create a SPARK object from a giotto object

2.  **spark.vc** Fits the count-based spatial model to estimate the
    parameters, see `spark.vc` for additional parameters

3.  **spark.test** Testing multiple kernel matrices

Publication: [doi:10.1101/810903](https://doi.org/10.1101/810903)

## Examples

``` r
g <- GiottoData::loadGiottoMini("visium")

spark(g)
```
