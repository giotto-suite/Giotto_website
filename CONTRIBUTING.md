---
title: "How to Contribute?"
output: 
  html_document:
    number_sections: true
    toc: true
pkgdown:
  as_is: true
vignette: >
  %\VignetteIndexEntry{How to Contribute?}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

# Contribution guideline

We welcome contributions or suggestions from other developers. Please contact us if you have questions or would like to discuss an addition or major modifications to the Giotto main code. The source code for Giotto Suite may be found on our [GitHub repository](https://github.com/drieslab/Giotto/).


# Pull request process

The *Giotto* packages exist at the drieslab repository on GitHub. Some
guidelines for pull requests (PRs) are the following:

-   Edits to code should start on a new and purpose-made branch based on
    the packages's dev branch (one of the following).

    -   `drieslab/Giotto@suite_dev`

    -   `drieslab/GiottoVisuals@dev`

    -   `drieslab/GiottoClass@dev`

    -   `drieslab/GiottoUtils@dev`

-   PRs when ready, should then be made to dev branches of the *Giotto*
    modules.

-   PRs will be reviewed by a core dev member after which a decision is
    made if it can be directly added to dev or if there are further
    revisions that are desired.



# Coding Style  

Following a particular programming style will help programmers read and
understand source code conforming to the style, and help to avoid
introducing errors. Here we present a small list of guidelines on what
is considered a good practice when writing R code in Giotto package.
Most of them are adapted from Bioconductor - coding style or Google’s R
Style Guide. These guidelines are preferences and strongly encouraged!

-   **Overall style**

    -   We follow the BioConductor styling. You can set this up easily
        by installing *biocthis* and *styler.*


```{r, eval=FALSE}
# package installations
BiocManager::install("biocthis")
install.packages("styler")

# styling a file
b_style <- biocthis::bioc_style()
styler::style_file(path = "[???]", transformers = b_style)

# styling the active package (may lead to lots of conflicts)
# !! This should only be done be core devs with a lot of caution and forewarning !!
styler::style_pkg(transformers = b_style)
```



    -   setting your default indent size to be 4 spaces instead of 2 is
        also recommended.

<!-- -->

-   **Function types**

    -   **exported** - Core functionality for users to directly use.
        These should have clear names and documentation

    -   **exported utility** - Secondary functionalities that are
        helpful to also have available, but are not directly related to
        data processing, analysis, and visualization. Examples are
        `dt_to_matrix()` or `wrap_msg()`

        -   another reason for this type of function is because Giotto
            is modular and some functions that are not expected to be
            commonly used by end users also need to be exported so that
            they are available across the Giotto ecosystem.

    -   **internal** - Functions that are never intended to be used
        outside of a module package. These are functions only relevant
        to the internals of one package, for example `.detect_in_dir()`
        from *Giotto's* internals which is pretty nondescript and mainly
        there to help with code organization.

-   **Naming**

    -   Use `camelCase` for **exported** functions. ex: `functionName()`

    -   Use `snake_case` for **exported utiliity** functions. ex:
        `function_name()`

    -   Use `.` prefix AND `snake_case` for **internal** functions. ex:
        `.function_name()`

    -   Use `snake_case` for parameter/argument names.

    -   Never use `.` as a separator in function naming. (in the S3
        class system, `fun(x)` where `x` is class foo will dispatch to
        `fun.foo()`)

-   **Use of symbols** Do not use any non-UTF-8 characters unless
    provided as the escape code. For example: `\u00F6` for `ö` Beyond
    these guidelines, *styler* should be used in order to maintain code
    uniformity.


# Stat functions  

Most Giotto commands can accept several matrix classes (`DelayedMatrix`,
`SparseM`, Matrix or base `matrix`). To facilitate this we provide
flexible wrappers that work on any type of matrix class.

-   `mean_flex()`: analogous to `mean()`

-   `rowSums_flex()`: analogous to `rowSums()`

-   `rowMeans_flex()`: analogous to `rowMeans()`

-   `colSums_flex()`: analogous to `colSums()`

-   `colMeans_flex()`: analogous to `colMeans()`

-   `t_flex()`: analogous to `t()`

-   `cor_flex()`: analogous to `cor()`



# Auxiliary functions  

Giotto has a number of auxiliary or convenience functions that might
help you to adapt your code or write new code for Giotto. We encourage
you to use these small functions to maintain uniformity throughout the
code.

-   `lapply_flex()`: analogous to lapply() and works for both windows
    and unix systems

-   `all_plots_save_function()`: compatible with Giotto instructions and
    helps to automatically save generated plots

-   `plot_output_handler()`: further wraps all_plots_save_function and
    includes handling for return_plot and show_plot and Giotto
    instructions checking

-   `determine_cores()`: determine the number of cores to use if a user
    does not set this explicitly

-   `get_os()`: identify the operating system

-   `update_giotto_params()`: will catch and store the parameters for
    each used command on a `giotto` object

-   `wrap_txt()`, `wrap_msg()`, etc: text and message formatting
    functions

-   `vmsg()`: framework for Giotto’s verbosity-flagged messages

-   `package_check()`: to check if a package exists, works for packages
    on CRAN, Bioconductor and Github

    -   Should be used within your contribution code if it requires the
        use of packages not in *Giotto's* `DESCRIPTION` file's depends
        imports section.

    -   Has the additional benefit that it will suggest to the user how
        to download the package if it is not available. To keep the size
        of *Giotto* within limits we prefer not to add too many new
        dependencies.


# Package Imports

*Giotto* tracks packages and functions to import in a centralized
file. When adding code that requires functions from another package,
add the *roxygen* tags to the `package_imports.R` file for that *Giotto*
module.


# Getters and Setters

*Giotto* stores information in different
[slots](https://drieslab.github.io/Giotto_website/articles/articles/structure.html#giotto-object-structure),
which can be accessed through these getters and setters functions. They
can be found in the
[`accessors.R`](https://github.com/drieslab/Giotto/blob/suite/R/accessors.R)
file.

`setGiotto()`: Sets any *Giotto* subobject

`getCellMetadata()`: Gets cell metadata

`setCellMetadata()`: Sets cell metadata

`getFeatureMetadata()`: Gets feature metadata

`getFeatureMetadata()`: Sets feature metadata

`getExpression()`: To select the expression matrix to use

`setExpression()`: Sets a new expression matrix to the expression slot

`getSpatialLocations()`: Get spatial locations to use

`setSpatialLocations()`: Sets new spatial locations

`getDimReduction()`: To select the dimension reduction values to use

`setDimReduction()`: Sets new dimension reduction object

`getNearestNetwork()`: To select the nearest neighbor network (kNN or
sNN) to use

`setNearestNetwork()`: Sets a new nearest neighbor network (kNN or sNN)

`getSpatialNetwork()`: To select the spatial network to use

`setSpatialNetwork()`: Sets a new spatial network

`getPolygonInfo()`: Gets spatial polygon information

`setPolygonInfo()`: Set new spatial polygon information

`getFeatureInfo()`: Gets spatial feature information

`setFeatureInfo()`: Sets new spatial feature information

`getSpatialEnrichment()`: Gets spatial enrichment information

`setSpatialEnrichment()`: Sets new spatial enrichment information

`getMultiomics()`: Gets multiomics information

`setMultiomics()`: Sets multiomics information


# Python code

To use Python code we prefer to create a python wrapper/functions around
the python code, which can then be sourced by *reticulate*. As an
example we show the basic principles of how we implemented the Leiden
clustering algorithm.

1.  write python wrapper and store as `python_leiden.py` in
    `/inst/python`:

```{python, eval=FALSE, python.reticulate = FALSE}
import igraph as ig 
import leidenalg as la 
import pandas as pd
import networkx as nx

def python_leiden(df, partition_type, initial_membership=None, weights=None, n_iterations=2, seed=None, resolution_parameter = 1):
    
    # create networkx object
    Gx = nx.from_pandas_edgelist(df = df, source = 'from', target =  'to', edge_attr = 'weight')  

    # get weight attribute
    myweights = nx.get_edge_attributes(Gx, 'weight')

    ....

    return(leiden_dfr)
```

2.  source python code with *reticulate*:

```{r, eval=FALSE}
python_leiden_function = system.file("python", "python_leiden.py", package = 'Giotto') reticulate::source_python(file = python_leiden_function)
```

3.  use python code as if R code: See `doLeidenCLuster()` for more
    detailed information.

```{python, eval=FALSE, python.reticulate = FALSE}
pyth_leid_result = python_leiden(
    df = network_edge_dt,
    partition_type = partition_type, 
    initial_membership = init_membership, 
    weights = 'weight', 
    n_iterations = n_iterations,
    seed = seed_number, 
    resolution_parameter = resolution
)
```

# Contributing tutorials to the website

If you would like to add a new example to our website <https://drieslab.github.io/Giotto_website/>, please follow these steps:


- 0. Clone the Giotto_website repository

Clone the repository from <https://github.com/drieslab/Giotto_website> and switch to the "suite" branch.

- 1. Create a new R markdown

Create a new .Rmd file under the folder "vignettes". 

If you are planning to include figures as part of the tutorial, create a new folder under "vignettes/images" with the same name as your .Rmd file.

All scripts need a header like shown below that starts at line 1.

Here you should edit the title.

```
---
title: "TITLE TO USE"
output: 
  html_document:
    number_sections: true
    toc: true
pkgdown:
  as_is: true
vignette: >
  %\VignetteIndexEntry{TITLE TO USE}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---
```

- 2. Absolutely no `eval=TRUE` for example code.

To save time when rendering the website, all chunks should not evaluate the code. Image results should be
included via linking or a `knitr` chunk of this style:

```
```{r, echo=FALSE, out.width="80%", fig.align="center"}
knitr::include_graphics("images/TUTORIAL_FOLDER/#_IMAGE_NAME.png")
```
```

The upper case sections just show which areas should be edited, not that they
need to be upper case

- 3. Create your example

Add the text and code of your tutorial. Please use similar variable names to previous tutorials, we have created a list of common variables and default values in this [spreadsheet](https://docs.google.com/spreadsheets/d/1ciK9-A0wR7IRotM6XwiTlImciDRnH-wMhJ0FKBcIWCI/edit?gid=0#gid=0).

- 4. Session info

Files should have a session info section at the end of the tutorial.

- 5. Preview the document with knitr

knit the document to check if the vignette looks how you like, and that it actually
knits properly.

Optionally, you can run pkgdown::build_site(), but this may be hard to run locally.

- 6. Edit the pkgdown.yml file

pkgdown.yml at the repo toplevel details how the links are set up between
documents in the website.

For most new articles:

- Under navbar:
  - Determine which section your tutorial fits better between Get started, Examples, and Tutorials.
  - Select or setup the subsection if needed.
  - Add a **text** (what menu name it has) and **href** ("articles/VIGNETTE_NAME.html") field for your new article.

- Under articles:
  - Find the appropriate title for your new vignette (should be the same to the previous navbar section).
  - Add your new vignette, with the same name as the VIGNETTE_NAME used for the href section used in navbar (minus the `.html`).

- 7. Push the changes to Github. If you are an outside collaborator, you may need to create a Pull Request.

Changes usually take roughly 30 min to build and deploy on the website.



