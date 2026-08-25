# Giotto-specific Dispatch Functions

## 1 Stat functions

Most Giotto commands can accept several matrix classes (`DelayedMatrix`,
`SparseM`, Matrix or base `matrix`). To facilitate this we provide
flexible wrappers that dispatch to our preferred methods for these
operations.

- [`mean_flex()`](https://giotto-suite.github.io/GiottoClass/reference/mean_flex.html):
  analogous to [`mean()`](https://rdrr.io/r/base/mean.html).

- [`rowSums_flex()`](https://giotto-suite.github.io/GiottoClass/reference/rowSums_flex.html):
  analogous to [`rowSums()`](https://rdrr.io/r/base/colSums.html).

- [`rowMeans_flex()`](https://giotto-suite.github.io/GiottoClass/reference/rowMeans_flex.html):
  analogous to [`rowMeans()`](https://rdrr.io/r/base/colSums.html).

- [`colSums_flex()`](https://giotto-suite.github.io/GiottoClass/reference/colSums_flex.html):
  analogous to [`colSums()`](https://rdrr.io/r/base/colSums.html).

- [`colMeans_flex()`](https://giotto-suite.github.io/GiottoClass/reference/colMeans_flex.html):
  analogous to [`colMeans()`](https://rdrr.io/r/base/colSums.html).

- [`t_flex()`](https://giotto-suite.github.io/GiottoClass/reference/t_flex.html):
  analogous to [`t()`](https://rdrr.io/r/base/t.html).

- [`cor_flex()`](https://giotto-suite.github.io/GiottoClass/reference/cor_flex.html):
  analogous to [`cor()`](https://rdrr.io/r/stats/cor.html).

## 2 Auxiliary functions

Giotto has a number of auxiliary or convenience functions that might
help you to adapt your code or write new code for Giotto. We encourage
you to use these small functions to maintain uniformity throughout the
code.

- `lapply_flex()`: analogous to lapply() and works for both windows and
  unix systems.

- `all_plots_save_function()`: compatible with Giotto instructions and
  helps to automatically save generated plots.

- `plot_output_handler()`: further wraps all_plots_save_function and
  includes handling for return_plot and show_plot and Giotto
  instructions checking.

- `determine_cores()`: determine the number of cores to use if a user
  does not set this explicitly.

- `get_os()`: identify the operating system.

- [`update_giotto_params()`](https://giotto-suite.github.io/GiottoClass/reference/update_giotto_params.html):
  will catch and store the parameters for each used command on a
  `giotto` object.

- `wrap_txt()`, `wrap_msg()`, etc: text and message formatting
  functions.

- `vmsg()`: framework for Giotto’s verbosity-flagged messages.

- `package_check()`: to check if a package exists, works for packages on
  CRAN, Bioconductor and Github.

  - Should be used within your contribution code if it requires the use
    of packages not in *Giotto’s* `DESCRIPTION` file’s depends imports
    section.

  - Has the additional benefit that it will suggest to the user how to
    download the package if it is not available. To keep the size of
    *Giotto* within limits we prefer not to add too many new hard
    dependencies (packages in Depends or Suggests).
