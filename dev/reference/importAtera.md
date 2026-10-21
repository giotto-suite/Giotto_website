# Import an Atera dataset

Creates a reader with functions for converting individual pieces of
Atera data into Giotto-compatible representations.

Atera v1 output ships zarr archives only and is read through GiottoDisk:
pass a `backend` to get a `GiottoDisk::importAteraDisk()` reader, which
writes each data type to the on-disk project. Atera preview data in the
Xenium layout (parquet / h5 files) is read with
[`importXenium()`](https://giottosuite.com/dev/reference/importXenium.md)
and
[`createGiottoXeniumObject()`](https://giottosuite.com/dev/reference/createGiottoXeniumObject.md).

## Usage

``` r
importAtera(atera_dir = NULL, qv_threshold = 20, backend = NULL)
```

## Arguments

- atera_dir:

  Atera output directory

- qv_threshold:

  Minimum Phred-scaled quality score cutoff to be included as a
  subcellular transcript detection (default = 20). Only applies when
  transcript-level data is present.

- backend:

  a `gsource`-inheriting project backend, or a path to one. Required for
  Atera v1 (zarr) output: creates the `giotto` object as a managed
  on-disk project.

## Value

`AteraDiskReader` object when `backend` is set, else `AteraReader`

## Examples

``` r
if (FALSE) { # \dontrun{
x <- importAtera("path/to/atera_outs", backend = "path/to/project")
g <- x$create_gobject()
} # }
```
