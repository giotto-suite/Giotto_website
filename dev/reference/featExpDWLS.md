# featExpDWLS

Compute predicted feature expression value by spatialDWSL results and
average feature expression for cell type

## Usage

``` r
featExpDWLS(gobject, spat_unit = NULL, feat_type = NULL, ave_celltype_exp)
```

## Arguments

- gobject:

  giotto object

- spat_unit:

  spatial unit (e.g. 'cell')

- feat_type:

  feature type (e.g. 'rna')

- ave_celltype_exp:

  data.table of feature expression in each cell type

## Value

matrix
