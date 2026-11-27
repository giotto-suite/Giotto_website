# Python in Giotto Suite

## 1 How it works

Most of Giotto Suite runs without Python. A few functions wrap a Python
tool, such as cellpose for cell segmentation or Scrublet for doublet
detection. These need no setup:

- each tool installs its own Python environment the first time it runs,
  and reuses it afterwards;
- each tool runs in a separate R session (a worker), so Python never
  starts in your own R session, and tools that need different Python or
  package versions work side by side in one analysis;
- you can use your own Python installation instead, for every tool or
  per tool.

There is no Giotto Python environment to install and no conda is needed.
The environments are built by [uv](https://docs.astral.sh/uv/) through
[reticulate](https://rstudio.github.io/reticulate/); reticulate
downloads uv itself.

## 2 What you need

Two R packages, once:

``` r

install.packages(c("reticulate", "callr")) # reticulate 1.41 or later
```

The first run of a tool needs internet.

## 3 Running a Python tool

Call the function as any other; there is nothing to set up first.

``` r

library(Giotto)

g <- GiottoData::loadGiottoMini("visium")

# first run: installs Scrublet in its own environment
g <- GiottoConnect::runScrublet(g)
```

The first run of a tool says that its environment is being installed:

    Installing the Python environment for scrublet (first use only).
    This needs internet and can take a few minutes; later runs reuse it.
    To use your own Python installation instead:
      options(giotto.py_python = list(scrublet = "/path/to/python"))

Scrublet installs in about a minute. Deep learning tools such as
cellpose and StarDist download several hundred megabytes. Later runs
start in about a second.

Tools exchange large data, such as images and segmentation masks, as
files rather than copying them between R sessions.

## 4 Functions that use Python

| Function | Python tool |
|----|----|
| [`doCellposeSegmentation()`](https://giottosuite.com/dev/reference/doCellposeSegmentation.md) | cellpose |
| [`doMesmerSegmentation()`](https://giottosuite.com/dev/reference/doMesmerSegmentation.md), [`doCellSegmentation()`](https://giottosuite.com/dev/reference/doCellSegmentation.md) | deepcell (Mesmer) |
| [`doStardistSegmentation()`](https://giottosuite.com/dev/reference/doStardistSegmentation.md) | StarDist |
| [`preprocessImageToMatrix()`](https://giottosuite.com/dev/reference/preprocessImageToMatrix.md), [`estimateAutomatedImageRegistrationWithSIFT()`](https://giottosuite.com/dev/reference/estimateAutomatedImageRegistrationWithSIFT.md) | scikit-image |
| [`to_simple_tif()`](https://giotto-suite.github.io/GiottoClass/reference/to_simple_tif.html), [`tif_metadata()`](https://giotto-suite.github.io/GiottoClass/reference/tif_metadata.html) (for formats without XML metadata) | tifffile |
| [`runONTraCV1()`](https://giottosuite.com/dev/reference/runONTraCV1.md) | ONTraC 1.x |
| [`GiottoConnect::runScrublet()`](https://giotto-suite.github.io/GiottoConnect/reference/runScrublet.html) | Scrublet |
| [`GiottoConnect::runONTraC()`](https://giotto-suite.github.io/GiottoConnect/reference/runONTraC.html) | ONTraC |

[`GiottoConnect::spatialdataToGiotto()`](https://giotto-suite.github.io/GiottoConnect/reference/spatialdataToGiotto.html)
and
[`GiottoConnect::createBentoAdata()`](https://giotto-suite.github.io/GiottoConnect/reference/createBentoAdata.html)
still start Python in your own R session.

## 5 Using your own Python

To run tools with a Python installation you manage yourself, for example
for a fixed, validated set of versions, point Giotto to it. Its packages
are then yours to install; nothing is installed into it.

``` r

# one Python for every tool
options(giotto.py_python = "/path/to/venv/bin/python")

# or one per tool, by the tool's name; other tools keep their own environment
options(giotto.py_python = list(
    cellpose = "/path/to/cellpose-env/bin/python"
))
```

The segmentation functions also take the path directly, as `python_env`.

## 6 Recorded versions

The Python version and the version of each package a tool used are
recorded. GiottoConnect tools store them with the step in the object’s
history, which
[`saveGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/saveGiotto.html)
keeps:

``` r

h <- objHistory(g)
h[[length(h)]]$py_versions
#>  python scrublet
#>  "3.13"  "0.2.3"
```

## 7 Offline use and HPC

On a cluster whose compute nodes have no internet, run each tool once on
a node that has internet, with the uv cache on shared storage, then
switch downloads off on the compute nodes:

``` sh
# on a login node with internet: run each tool once
export UV_CACHE_DIR=/shared/storage/uv-cache

# on the compute nodes
export UV_CACHE_DIR=/shared/storage/uv-cache
export UV_OFFLINE=1
```

A tool whose packages are not in the cache then stops with a message
saying so.

## 8 Troubleshooting

An error in a tool is returned as one R error with the tool’s Python
message. With your own Python, a missing package is named in the error.

To debug a tool, run it in your own R session instead of a worker. That
session then starts Python and keeps that tool’s environment until you
restart R.

``` r

options(giotto.py_isolate = FALSE)
```

For other problems, see
[troubleshooting](https://giottosuite.com/dev/articles/troubleshooting.md).
