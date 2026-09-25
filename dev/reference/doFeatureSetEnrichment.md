# Gene Set Enrichment Analysis via the external GSEA tool

Run Gene Set Enrichment Analysis by driving the Broad Institute's GSEA
command-line application over a ranked feature list.

**This is not one of Giotto's spatial enrichment methods and does not
behave like them.** It takes no `giotto` object, reads and writes files
rather than object slots, and requires a separately installed Java
executable plus a downloaded MSigDB collection. Its input is a ranked
`.rnk` file, typically built from marker results. For per-cell scoring
of a signature against a Giotto object, see
[`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)
and the feature set enrichment family instead.

## Usage

``` r
doFeatureSetEnrichment(
  dryrun = TRUE,
  path_to_GSEA = NULL,
  GSEA_dataset = NULL,
  GSEA_ranked_file = NULL,
  output_folder = NULL,
  name_analysis_folder = "my_GSEA_analysis",
  collapse = "false",
  mode = c("Abs_max_of_probes", "Max_probe", "Median_of_probes", "Mean_of_probes",
    "Sum_of_probes"),
  norm = "meandiv",
  nperm = 1000,
  scoring_scheme = "weighted",
  plot_top_x = 20,
  set_max = 500,
  set_min = 15
)
```

## Arguments

- dryrun:

  do a dry run, default TRUE.

- path_to_GSEA:

  path to GSEA command line executable, e.g. gsea-XXX.jar. See details
  (1.) for more information.

- GSEA_dataset:

  path to a Human/Mouse collection from GSEA, e.g. Hallmarks C1. See
  details (2.) for more information.

- GSEA_ranked_file:

  path to .rnk file for GSEA. See details (3.) for more information

- output_folder:

  path to which the GSEA results will be saved. Default is current
  working directory.

- name_analysis_folder:

  default output subdirectory prefix to which results are saved. Will
  live within output_folder; equivalent of "Analysis Name" in GSEA
  Application.

- collapse:

  only 'false' is supported. This will use your dataset as-is, in the
  original format.

- mode:

  option selected in Advanced Field "Collapsing Mode for Probe Sets =\>
  1 gene"

- norm:

  normalization mode; only meandiv is supported.

- nperm:

  number of permutations, default 1000

- scoring_scheme:

  Default "weighted", equivalent of "enrichment statistic" in GSEA
  Application

- plot_top_x:

  Default 20, number of enrichment plots to produce.

- set_max:

  default 500, equivalent to "max size; exclude larger sets" in Basic
  Fields in GSEA Application

- set_min:

  default 15, equivalent to "min size; exclude smaller sets" in Basic
  Fields in GSEA Application

## Value

data.table

## Details

NECESSARY PREREQUISITES

1.  download and install the COMMAND line (all platforms) gsea-XXX.jar
    https://www.gsea-msigdb.org/gsea/downloads.jsp 1.1. download zip
    file 1.2. unzip and move to known location (e.g. in
    path/to/your/applications/gsea/GSEA_4.3.2)

2.  download the Human and Mouse collections
    https://www.gsea-msigdb.org/gsea/msigdb/index.jsp or zipped folder
    https://www.gsea-msigdb.org/gsea/downloads.jsp (all downloaded)

3.  create ranked gene lists format: data.table or data.frame with 2
    columns column 1 = gene symbols, column 2 = weight or rank metric
    for more details, see:
    https://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#RNK:*Ranked_list_file_format*.28.2A.rnk.29

For more information on parameter conventions, please reference GSEA's
documentation here:
https://www.gsea-msigdb.org/gsea/doc/GSEAUserGuideTEXT.htm#\_Syntax

## See also

[`runSpatialEnrich()`](https://giottosuite.com/dev/reference/runSpatialEnrich.md)
for per-cell signature scoring on a giotto object, which is a different
operation despite the similar name.

## Examples

``` r
# Requires a separately installed GSEA executable and an MSigDB collection,
# so this cannot run in an example. `dryrun = TRUE` (the default) prints the
# command that would be issued rather than running it.
if (FALSE) { # \dontrun{
doFeatureSetEnrichment(
    dryrun = TRUE,
    path_to_GSEA = "~/GSEA_4.3.2/gsea-cli.sh",
    GSEA_dataset = "~/msigdb/h.all.v2023.1.Hs.symbols.gmt",
    GSEA_ranked_file = "~/my_markers.rnk",
    output_folder = tempdir()
)
} # }
```
