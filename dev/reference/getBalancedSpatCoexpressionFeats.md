# Get balanced spatial coexpression features

Extract features from spatial co-expression modules in a balanced manner

## Usage

``` r
getBalancedSpatCoexpressionFeats(
  spatCorObject,
  maximum = 50,
  rank = c("weighted", "random", "informed"),
  informed_ranking = NULL,
  seed = NA,
  verbose = TRUE
)
```

## Arguments

- spatCorObject:

  spatial correlation object

- maximum:

  maximum number of genes to get from each spatial co-expression module

- rank:

  ranking method (see details)

- informed_ranking:

  vector of ranked features

- seed:

  seed

- verbose:

  verbosity

## Value

balanced vector with features for each co-expression module

## Details

There are 3 different ways of selecting features from the spatial
co-expression modules

1.  **weighted:** Features are ranked based on summarized pairwise
    co-expression scores

2.  **random:** A random selection of features, set seed for
    reproducibility

3.  **informed:** Features are selected based on prior
    information/ranking
