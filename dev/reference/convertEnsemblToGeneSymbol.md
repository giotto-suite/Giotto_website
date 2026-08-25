# convertEnsemblToGeneSymbol

This function convert ensembl gene IDs from a matrix to official gene
symbols

## Usage

``` r
convertEnsemblToGeneSymbol(matrix, species = c("mouse", "human"))
```

## Arguments

- matrix:

  an expression matrix with ensembl gene IDs as rownames

- species:

  species to use for gene symbol conversion

## Value

expression matrix with gene symbols as rownames

## Details

This function requires that the biomaRt library is installed
