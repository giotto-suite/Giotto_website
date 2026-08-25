# Read a structured folder of exported data

Framework function for reading the exported folder of a spatial method
and detecting the presence of needed files. NULL values denote missing
items.  
`.read_data_folder()` should not be called directly. Instead, specific
reader functions should be built using it as a base.

## Usage

``` r
.read_data_folder(
  spat_method = NULL,
  data_dir = NULL,
  dir_items,
  data_to_use,
  load_format = NULL,
  require_data_DT,
  cores = NA,
  verbose = NULL,
  toplevel = 2L
)

.read_merscope_folder(
  merscope_dir,
  data_to_use,
  polygon_format = "hdf5",
  version = 1,
  cores = NA,
  verbose = NULL
)
```

## Arguments

- spat_method:

  spatial method for which the data is being read

- data_dir:

  exported data directory to read from

- dir_items:

  named list of directory items to expect and keywords to match

- data_to_use:

  character. Which type(s) of expression data to build the gobject with.
  Values should match with a *workflow* item in require_data_DT (see
  details)

- require_data_DT:

  data.table detailing if expected data items are required or optional
  for each `data_to_use` *workflow*

- cores:

  cores to use

- verbose:

  be verbose

- toplevel:

  stackframes back where the user-facing function was called. default is
  one stackframe above `.read_data_folder`.

## Value

data.table

## Details

**Steps performed:**

- 1\. detection of items within `data_dir` by looking for keywords
  assigned through `dir_items`

- 2\. check of detected items to see if everything needed has been
  found. Dictionary of necessary vs optional items for each
  `data_to_use` *workflow* is provided through `require_data_DT`

- 3\. if multiple filepaths are found to be matching then select the
  first one. This function is only intended to find the first level
  subdirectories and files.

**Example reader implementation:**


      foo <- function(x_dir,
                      data_to_use,
                      cores = NA,
                      verbose = NULL) {
        dir_items <- list(
          data1 = "regex_pattern1",
          data2 = "regex_pattern2",
          data3 = "regex_pattern3"
        )

        # DT of info to check directory for. Has 3 cols
        require_data_DT <- data.table::data.table(
          workflow = "a", # data_to_use is matched against this
          item = c(
            "data1",
            "data2",
            "data3"
          ),
          needed = c(
            FALSE, # data1 optional for this workflow (if missing: warn)
            TRUE,  # data2 vital for this workflow (if missing: error)
            TRUE   # data3 vital for this workflow (if missing: error)
          )
        )

        .read_data_folder(
          spat_method = "x_method",
          data_dir = x_dir,
          dir_items = dir_items,
          data_to_use = data_to_use,
          require_data_DT = require_data_DT,
          cores = cores,
          verbose = verbose
        )
      }

## Functions

- `.read_data_folder()`: Should not be used directly

- `.read_merscope_folder()`: Read a structured MERSCOPE folder
