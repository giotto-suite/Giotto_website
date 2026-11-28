# Adding methods and tools

This guide describes how to add an external spatial method to the Giotto
Suite, either by reimplementing it natively or by connecting the
original tool. It reuses what the Suite already has: the five analysis
verbs and their `Param` classes, the setters for every slot, the
analysis history, and `package_check()` for tools that are installed
only when used. No method needs its own package, and nothing is
installed for users who never run it.

## 1 Three kinds of integration

- **A native reimplementation** recomputes a published method inside
  Giotto, built from Suite building blocks. The BANKSY embedding
  ([`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md))
  is the example: a stored spatial network, the Suite’s PCA, and only
  BANKSY’s neighbour weights and gradient as new code. It lives in
  **Giotto**.
- **An engine package** holds a method’s computation in its own small R
  package with no Giotto dependency, and Giotto adds the `Param`, the
  verb method and the wrapper. HMRF (`spatialHMRF`, used by
  [`runHMRF()`](https://giottosuite.com/dev/reference/runHMRF.md)) and
  spatialDWLS work this way. Use it when the engine is substantial,
  useful on its own, or credited to other authors; the package is in
  Giotto’s `Suggests` and checked when the method runs.
- **A connection** runs the original tool and moves data in and out, for
  example ONTraC (Python) or CellChat (R). It lives in
  **GiottoConnect**, one file per tool: `R/tool-<name>.R`.

## 2 Reuse before writing

Build on what the Suite already has and write only what is specific to
the method. Spatial neighbours come from a stored spatial network
([`createSpatialNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/createSpatialNetwork.html)),
PCA from `reduceData(x, pcaParam())`, clustering from the existing
clustering functions. BANKSY’s native embedding adds only its neighbour
weights and gradient
([`neighborhood_operators()`](https://giottosuite.com/dev/reference/neighborhood_operators.md))
on top of a stored kNN network. If an existing building block is too
slow for the new method, improve it there rather than working around it.

## 3 Verbs return, wrappers write

Each method is a `Param` class plus a method on one of the five verbs,
chosen by what it returns:

| Verb | Returns |
|----|----|
| [`processData()`](https://giottosuite.com/dev/reference/processData.md) | values of the same shape (normalized, smoothed) |
| [`filterData()`](https://giotto-suite.github.io/GiottoClass/reference/filterData.html) | the IDs to keep |
| [`reduceData()`](https://giotto-suite.github.io/GiottoClass/reference/reduceData.html) | an embedding or decomposition |
| [`clusterData()`](https://giottosuite.com/dev/reference/clusterData.md) | one label per cell |
| [`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md) | statistics and other outputs |

The method on a data class (a matrix, a table) returns what its verb
promises and never touches a giotto object. A thin `run<Name>()` wrapper
reads the inputs from the giotto object, calls the verb, and writes the
result with the existing setters.

## 4 Where results go

Results go into the slots that already exist:

| Output | Slot | Written with |
|----|----|----|
| a label or value per cell | cell metadata | [`addCellMetadata()`](https://giotto-suite.github.io/GiottoClass/reference/addCellMetadata.html) |
| a value per feature | feature metadata | [`addFeatMetadata()`](https://giotto-suite.github.io/GiottoClass/reference/addFeatMetadata.html) |
| cells x dimensions | dimension reduction | [`createDimObj()`](https://giotto-suite.github.io/GiottoClass/reference/createDimObj.html) + [`setDimReduction()`](https://giotto-suite.github.io/GiottoClass/reference/setDimReduction.html) |
| cells x categories (proportions, probabilities) | spatial enrichment | [`createSpatEnrObj()`](https://giotto-suite.github.io/GiottoClass/reference/createSpatEnrObj.html) + [`setSpatialEnrichment()`](https://giotto-suite.github.io/GiottoClass/reference/setSpatialEnrichment.html) |
| features x cells values | expression | [`setExpression()`](https://giotto-suite.github.io/GiottoClass/reference/setExpression.html) |
| a graph on expression or an embedding | nearest-neighbour network | [`setNearestNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/setNearestNetwork.html) |
| a spatial graph | spatial network | [`setSpatialNetwork()`](https://giotto-suite.github.io/GiottoClass/reference/setSpatialNetwork.html) |
| anything else (interaction tables, fitted models, tool objects) | none | returned to the caller |

## 5 Plots

Results in existing slots can be drawn with existing plots, so most
integrations need none of their own. ONTraC is the example: niche
clusters with `spatPlot2D(cell_color = )`, their probabilities with
`spatCellPlot2D(spat_enr_names = )`, NT scores per cell type with
`ridgePlot(group_by = )`, and cell type composition with
[`plotLabelComposition()`](https://giotto-suite.github.io/GiottoVisuals/reference/plotLabelComposition.html).
List these in the wrapper’s help page.

When a tool has a view no Giotto plot covers, and that view only makes
sense for this tool, add one plot function to the tool’s file:

- name it `plot<Tool><What>()`, as `plotONTraCConnectivity()` (the graph
  of ONTraC’s niche clusters);
- read what it draws from the slots the wrapper wrote (for ONTraC, the
  spatial enrichment’s `misc`), never from the tool’s output files;
- put `ggplot2` (and any other plotting package) in `Suggests`, check it
  with `package_check()`, and return through
  [`GiottoVisuals::plot_output_handler()`](https://giotto-suite.github.io/GiottoVisuals/reference/plot_output_handler.html)
  so `show_plot`, `return_plot` and `save_plot` work as in the other
  Giotto plots.

A view that several tools would use belongs in GiottoVisuals instead.

## 6 Recording what was run

The wrapper ends with

``` r

update_giotto_params(gobject, description = "_<name>",
    attachments = list(param = param))
```

so the analysis history keeps the `Param` with its settings. A `Param`
holds settings only, never data.

## 7 Dependencies

- The tool is never in `Imports`. A CRAN or Bioconductor tool goes in
  `Suggests`. A tool only on GitHub gets an install hint from
  `package_check(repository = "github:owner/repo")` and is called with
  [`getExportedValue()`](https://rdrr.io/r/base/ns-reflect.html), so
  `R CMD check` stays clean; the Suite’s own engine packages
  (spatialHMRF, spatialDWLS) go in `Suggests` and `Remotes`. Every tool
  is checked with `package_check()` when the function runs.
- Python tools run in a separate R session through
  [`GiottoUtils::py_run()`](https://giotto-suite.github.io/GiottoUtils/reference/py_run.html)
  (or `py_run_cli()` for a command line program), in an environment
  built on first use, so tools with conflicting requirements can be used
  side by side. Pin the tool’s version, and record the returned
  `py_versions` with the `Param`.
- Tests use `skip_if_not_installed()`, so a broken tool release breaks
  only its own function.
- A function shared with another package is exported as a documented
  `snake_case` utility, not reached with `:::`.

## 8 Names and credit

- The `Param` class is named after the method: `ontracParam`,
  `cellchatParam`, `hmrfParam`. A connection’s or engine package’s
  wrapper is `run<Method>()`.
- A native reimplementation gets a descriptive name, not the tool’s, so
  a wrapper of the original can sit beside it:
  [`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md)
  next to
  [`GiottoConnect::runBanksy()`](https://giotto-suite.github.io/GiottoConnect/reference/runBanksy.html).
- Its help page names the original method and paper under `@references`,
  asks users to cite it, and says how it differs from the original and
  how closely it matches.

## 9 Checking an integration

- Compare against the original tool on the same input, with a seed, keep
  the comparison script outside the package (for example in
  `examples/<tool>_comparison/`), and report the difference in the pull
  request.
- A pull request adds one method. Changes to other methods or shared
  helpers, even improvements, go in a pull request of their own, so each
  can be reviewed and reverted alone.
- [`GiottoConnect::checkGiottoMethod()`](https://giotto-suite.github.io/GiottoConnect/reference/checkGiottoMethod.html)
  (and `expect_giotto_method()` in tests) checks a wrapper against these
  rules: which slots it wrote, that the history holds its `Param`, and
  that its help page has references.
