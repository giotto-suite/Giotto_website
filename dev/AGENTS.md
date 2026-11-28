# Giotto

The analysis package of the Giotto Suite: technology readers, processing
(normalization, filtering, PCA, clustering) and spatial methods (spatial
genes, domains, enrichment, interactions). The object model and the five
analysis verbs are in GiottoClass, plots in GiottoVisuals, disk-backed
data in GiottoDisk, conversions and external tools in GiottoConnect.

## Documentation map

| Doc | Role |
|----|----|
| `AGENTS.md` (this file) | Where things go and the rules for new code. Read first. |
| `.github/CONTRIBUTING.md` | Coding style, naming, the `*_flex` and helper functions. |
| `adr/` | Decisions and why (wrappers and verbs, lazy normalization, readers, `autoPcaParam`). Read before reversing a pattern. |
| Website, *Adding methods and tools* (`extending_giotto.Rmd` in Giotto_website) | The integration contract with its reasons, for contributors. |
| GiottoClass `AGENTS.md` | Classes, accessors, the verbs and their `Param` classes. |
| GiottoDisk `AGENTS.md` and its `giottodisk-method` skill | Disk-backed methods. |
| GiottoConnect `AGENTS.md` and its `giotto-integrate` skill | Wrapping an external tool; deciding where an integration belongs. |
| `NEWS.md` | Add an entry when you change behaviour, an argument or an export. |

## Where things go

| Work | Place |
|----|----|
| Reader for a technology’s raw output | `R/convenience_<platform>.R`, the reader pattern of ADR 0003 ([`importXenium()`](https://giottosuite.com/dev/reference/importXenium.md), [`importMerscope()`](https://giottosuite.com/dev/reference/importMerscope.md)); its disk-backed counterpart goes in GiottoDisk |
| A Suite-native method (a reimplementation built from existing steps) | `R/<method>.R`, a descriptive name rather than the tool’s ([`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md), not `runBanksy()`) |
| A method whose engine is its own package | the engine package (no Giotto dependency) in `Suggests` and `Remotes`; Giotto holds the param, the verb method and the wrapper (`R/hmrf.R` with spatialHMRF, `R/deconv-param.R` with spatialDWLS) |
| A wrapper that runs an external tool as is | GiottoConnect, not here |
| A disk-backed (streaming) method for a Giotto param | GiottoDisk, as a method on the same param (`GiottoDisk/R/stream-deconv.R`) |

## Rules for methods

1.  **A method is a `Param` and a verb.** A `<name>Param` class extends
    one of GiottoClass’s verb params; a method on
    [`processData()`](https://giottosuite.com/dev/reference/processData.md),
    `filterData()`, `reduceData()`,
    [`clusterData()`](https://giottosuite.com/dev/reference/clusterData.md)
    or
    [`analyzeData()`](https://giottosuite.com/dev/reference/analyzeData.md)
    takes plain data and returns the result; a thin `run<Name>()`
    wrapper reads with accessors, calls the verb and writes with setters
    (ADR 0001). Never read or write slots with `@`.
2.  **Backends are swappable.** When several engines do one job, a
    virtual param class with one concrete class per engine and a factory
    (`R/pca-param.R`, `R/deconv-param.R`, `R/spatautocor-param.R`).
    Extend an existing family before starting a new one.
3.  **Disk-backed objects work.** Check for a store
    (`inherits(m, "dataStore")`) and pass it on to the verb, never
    [`as.matrix()`](https://rdrr.io/r/base/matrix.html) a whole
    disk-backed matrix
    ([`runNeighborhoodPCA()`](https://giottosuite.com/dev/reference/runNeighborhoodPCA.md)
    shows the pattern). The streaming method itself is GiottoDisk work,
    in its own pull request.
4.  **Spatial methods take the user’s network.**
    `spatial_network_name = NULL` uses the object’s stored network;
    create one only when none exists.
5.  **Credit.** The param defines
    [`GiottoClass::methodCitation()`](https://giotto-suite.github.io/GiottoClass/reference/methodCitation.html);
    the help page names the original method and paper (`@references`
    with `\doi{}`), asks users to cite it, and says how a
    reimplementation differs and how closely it matches. The wrapper
    ends with `update_giotto_params(attachments = list(param = param))`.
6.  **Optional packages stay optional.** New packages go in `Suggests`
    and are checked with `package_check()` when the function runs;
    `Imports` only with a good reason (CONTRIBUTING.md).
7.  **Compare and check.** A reimplementation is compared with the
    original on the same input (script in `examples/<name>_comparison/`
    outside the package); tests use
    [`GiottoConnect::expect_giotto_method()`](https://giotto-suite.github.io/GiottoConnect/reference/checkGiottoMethod.html)
    when GiottoConnect is installed.
8.  **One change per pull request.** Refactors of other methods go in a
    pull request of their own.

## Development workflow

- **Branch:** `gsource` (the Suite’s development line); pull requests
  target `gsource`. GiottoClass and GiottoVisuals pins are in
  `DESCRIPTION` `Remotes:`.
- **Docs:** roxygen2 8.0.0 (`roxygen2::roxygenise()`); undo unrelated
  changes it makes to other `man/` files.
- **Tests:** `devtools::test()`; data from
  [`GiottoData::loadGiottoMini()`](https://giotto-suite.github.io/GiottoData/reference/loadGiottoMini.html),
  set up in `tests/testthat/setup.R` (no conda).
- **Style:** `.github/CONTRIBUTING.md` (camelCase user functions,
  snake_case arguments, `.internal_helpers()`), formatted with styler.
