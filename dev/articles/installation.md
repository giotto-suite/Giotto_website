# Installation

Giotto Suite needs R 4.4.1 or later. Python is optional.

## Install

``` r

install.packages("GiottoUtils",
    repos = c("https://giotto-suite.r-universe.dev", "https://cloud.r-project.org")
)
GiottoUtils::suite_install(ref = "disk_full", install_arrow = TRUE)
```

This installs Giotto, GiottoDisk for large datasets, and the optional
speed-ups (GiottoKernels, GiottoIngest, SedonaDB, smotif and others).
The first run builds *arrow* with zstd support from source, which can
take a while.

## More options

**Lighter install: Giotto and GiottoDisk only**

Skips the optional speed-ups. They can be added later, one by one.

``` r

GiottoUtils::suite_install("GiottoDisk", install_arrow = TRUE)
```

**Release version**

The current release of Giotto. GiottoDisk is not part of a release yet
and will be added in a future one.

``` r

install.packages("pak")
pak::pkg_install("giotto-suite/Giotto")
```

**Other branches**

`suite_install()` installs the Giotto Suite modules in the right order
from a chosen set of branches, set with `ref`:

| `ref`              | Installs                                             |
|--------------------|------------------------------------------------------|
| `"main"` (default) | the release branches                                 |
| `"dev"`            | the development branches                             |
| `"disk"`           | the branches GiottoDisk builds against               |
| `"disk_full"`      | `"disk"`, plus GiottoLens and the optional speed-ups |

``` r

GiottoUtils::suite_install(ref = "dev")
```

Add `dry_run = TRUE` to print the install commands without running them.
See the [`suite_install()`
reference](https://giotto-suite.github.io/GiottoUtils/reference/suite_install.html)
for all options.

**System requirements**

- **Build tools:** packages installed from GitHub may need the [Posit
  package development
  prerequisites](https://support.posit.co/hc/en-us/articles/200486498-Package-Development-Prerequisites)
  for your system.
- **{terra} on Linux:** needs GDAL (\>= 2.2.3), GEOS (\>= 3.4.0), PROJ
  (\>= 4.9.3) and sqlite3. On our AlmaLinux 8 HPC, gdal 3.6.4, geos
  3.11.1, proj 9.2.0 and sqlite3 3.37.2 work well. See the [{terra}
  repository](https://github.com/rspatial/terra) for details. On Windows
  and macOS, `install.packages("terra")` is enough.
- **R older than 4.4.1:** the release install (`ref = "main"`) switches
  to the R 4.4.0 branches automatically. On R older than 4.4.0, install
  {Matrix} 1.6-5 first:
  `remotes::install_version("Matrix", version = "1.6-5")`.

**Python features**

Most of Giotto runs without Python. A few functions use Python packages,
for example Leiden clustering through Python, cell segmentation and
image registration. To use them, create Giotto’s Python environment
once:

``` r

Giotto::installGiottoEnvironment()
```

You can also point Giotto at an existing environment; see the
[configuration
page](https://giottosuite.com/dev/articles/configuration.md).

## Help

Running into errors? See the [troubleshooting
page](https://giottosuite.com/dev/articles/troubleshooting.md) or open
an issue on [GitHub](https://github.com/giotto-suite/Giotto/issues).
Please include your R, Giotto and operating system versions.
