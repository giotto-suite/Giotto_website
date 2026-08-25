# Interoperability: SpatialData

## 1 Introduction

SpatialData is a versatile data framework for processing spatial omics
data in python. This tutorial demonstrates how to convert Giotto objects
to and from SpatialData object using
[`giottoToSpatialData()`](https://giotto-suite.github.io/GiottoClass/reference/giottoToSpatialData.html)
and
[`spatialdataToGiotto()`](https://giotto-suite.github.io/GiottoClass/reference/spatialdataToGiotto.html).

## 2 Set up Giotto Environment

``` r

# Ensure Giotto Suite is installed.
if(!"Giotto" %in% installed.packages()) {
  pak::pkg_install("giotto-suite/Giotto")
}

# Ensure GiottoData is installed.
if(!"GiottoData" %in% installed.packages()) {
  pak::pkg_install("giotto-suite/GiottoData")
}

# Ensure the Python environment for Giotto has been installed.
genv_exists <- Giotto::checkGiottoEnvironment()
if(!genv_exists){
  # The following command need only be run once to install the Giotto environment.
  Giotto::installGiottoEnvironment()
}

# If your conda giotto environment doesn't have installed the modules 'spatialdata' and 'scanpy', you can install them by running the following command:
reticulate::conda_install(envname = "giotto_env", packages = c("spatialdata", "scanpy"), pip = TRUE)
```

``` r

# load package
library(Giotto)

# Important: Specify a path to a Python executable within a conda or miniconda reticulate
# environment. If set to NULL (default), the Python executable within the previously
# installed Giotto environment will be used.
python_path <- NULL
```

### 2.1 Create a mini Giotto object

For the purpose of this demonstration, the pre-processed and analyzed
10X Visium Giotto mini object will be used. To test on different
datasets, you can choose from ‘visium’, ‘vizgen’, ‘cosmx’,
‘spatialgenomics’, ‘seqfish’, or ‘starmap’.

``` r

# Specify path for SpatialData object output directory
results_folder <- "/path/to/results/"

# Load mini object or giotto object
mini_gobject <- GiottoData::loadGiottoMini(dataset = "visium", 
                                           python_path = python_path)

# Replace saving directory
instructions(mini_gobject, "save_dir") <- results_folder
```

### 2.2 giottoToSpatialData()

When converting a Giotto object to a SpatialData object, please note
that you must supply a known spot radius for your corresponding dataset
for the creation of the ShapesModel in SpatialData. If spot radius is
unknown, an arbitrary value is sufficient to convert the object and
still be able to perform most of the analysis. The env_name must be the
name of the env with python reticulate installed.

``` r

giottoToSpatialData(mini_gobject,
                    spot_radius = 55,
                    python_path = python_path,
                    save_directory = results_folder)
```

To verify successful conversion, you can load the converted SpatialData
object in Python like this:

``` python
from spatialdata import SpatialData

converted_spatialdata = SpatialData.read(r.results_folder)
```

### 2.3 spatialDataToGiotto()

If you have your own SpatialData object that you have been using on your
analysis and would like to convert it to Giotto object, you must save
the SpatialData object on disk like this:

``` python
# Let's say your spatialdata object is called sdata:
sdata.write("save_folder")
```

After running this line in python, you should have a folder at the path
“save_folder” which will have subfolders named ‘images’, ‘shapes’, and
‘tables’ for each component of the SpatialData object.

Let’s say you already have the SpatialData object converted and saved on
disk from
[`giottoToSpatialData()`](https://giotto-suite.github.io/GiottoClass/reference/giottoToSpatialData.html).
If you had nearest neighbor or spatial networks created or stored within
your SpatialData, you can also include them in the conversion by either
providing a .txt file or a list of the names of the keys for these
networks.

``` r

converted_gobject <- spatialdataToGiotto(spatialdata_path = results_folder,
                                         n_key_added = "cell_rna_nn_network_keys_added.txt",
                                         spatial_n_key_added = "cell_rna_spatial_network_keys_added.txt",
                                         python_path = python_path)
```

### 2.4 Session Info

``` r

sessionInfo()
```
