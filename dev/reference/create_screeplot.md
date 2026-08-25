# create_screeplot

create screeplot with ggplot

## Usage

``` r
create_screeplot(eigs, ncp = 20, ylim = c(0, 20))
```

## Arguments

- eigs:

  numeric. Vector of pca eigenvalues

- ncp:

  numeric. max number of principal components to plot

- ylim:

  numeric. y-axis limits on scree plot

## Value

ggplot

## Examples

``` r
dr <- GiottoData::loadSubObjectMini("dimObj")
scree <- create_screeplot(methods::slot(dr, "misc")$eigenvalues)
scree
```
