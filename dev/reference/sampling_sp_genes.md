# sampling_sp_genes

function to select a set of spatial genes

## Usage

``` r
sampling_sp_genes(clust, sample_rate = 2, target = 500, seed = 10)
```

## Arguments

- clust:

  spatial gene clusters

- sample_rate:

  sampling rate, takes values equal or greater than 1

- target:

  target length of gene list

- seed:

  random seed

## Value

list

## Details

This function samples a subset of spatial genes among different
clusters, with size n = target. Number of samples from each cluster
denpends on the relative proportion of each cluster. Changing from equal
size by setting sample_rate = 1 to with exact proportion of each cluster
by setting sample_rate = +Inf
