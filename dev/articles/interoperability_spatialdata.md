# Interoperability: SpatialData

## 1 Introduction

SpatialData is a versatile data framework for processing spatial omics
data in python. This tutorial demonstrates how to convert a SpatialData
object saved on disk to a Giotto object with
[`GiottoConnect::spatialdataToGiotto()`](https://giotto-suite.github.io/GiottoConnect/reference/spatialdataToGiotto.html).

Exporting a Giotto object to SpatialData (`giottoToSpatialData()`) was
retired in GiottoClass 0.8.0; export will be revisited in GiottoConnect.

## 2 Set up

``` r

# Ensure Giotto Suite and GiottoConnect are installed.
if(!"Giotto" %in% installed.packages()) {
  pak::pkg_install("giotto-suite/Giotto")
}
if(!"GiottoConnect" %in% installed.packages()) {
  pak::pkg_install("giotto-suite/GiottoConnect")
}

library(Giotto)
library(GiottoConnect)
```

[`spatialdataToGiotto()`](https://giotto-suite.github.io/GiottoConnect/reference/spatialdataToGiotto.html)
runs Python in your R session, unlike the Python tools described in
[Python in Giotto
Suite](https://giottosuite.com/dev/articles/python.md). Give it a Python
installation that has the `spatialdata` and `scanpy` modules installed:

``` r

python_path <- "/path/to/python" # with spatialdata and scanpy installed
```

## 3 Save the SpatialData object

In Python, save your SpatialData object on disk:

``` python
# Let's say your spatialdata object is called sdata:
sdata.write("save_folder")
```

This creates a folder “save_folder” with subfolders ‘images’, ‘shapes’,
and ‘tables’ for each component of the SpatialData object.

## 4 spatialdataToGiotto()

If you had nearest neighbor or spatial networks created or stored within
your SpatialData, you can also include them in the conversion by either
providing a .txt file or a list of the names of the keys for these
networks.

``` r

converted_gobject <- spatialdataToGiotto(
    spatialdata_path = "save_folder",
    n_key_added = "cell_rna_nn_network_keys_added.txt",
    spatial_n_key_added = "cell_rna_spatial_network_keys_added.txt",
    python_path = python_path
)
```

## 5 Session Info

``` r

sessionInfo()
```
