# Read dataset from opened HDF5 with C functions

Read dataset from opened HDF5 with C functions

## Usage

``` r
.h5_read_bare(file, name = "", dapl)
```

## Arguments

- file:

  opened HDF5 file

- name:

  dataset name within

- dapl:

  HDF5 property list (H5Pcreate('H5P_DATASET_ACCESS'))

## Value

HDF5 contents
