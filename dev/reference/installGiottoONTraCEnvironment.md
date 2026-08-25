# installGiottoONTraCEnvironment

Installs a conda environment contains ONTraC. This includes a miniconda
installation and also a set of python packages that Giotto may often
use. See details for further information

## Usage

``` r
installGiottoONTraCEnvironment(
  python_version = "3.11.9",
  ontrac_version = "latest",
  mini_install_path = NULL,
  confirm = TRUE,
  envname = "giotto_ontrac_env",
  conda = "auto",
  force_miniconda = FALSE,
  force_environment = FALSE,
  verbose = NULL
)
```

## Arguments

- python_version:

  python version to use within the giotto conda environment. Default is
  v3.11.9

- ontrac_version:

  ONTraC version to install. Default is "latest"

- mini_install_path:

  (optional) desired miniconda installation location. Default is chosen
  by \`reticulate::install_miniconda()\`

- confirm:

  whether to pause for confirmation of conda environment install
  location (default = TRUE)

- envname:

  name to assign environment. Default = "giotto_ontrac_env"

- conda:

  either "auto" (default) to allow reticulate to handle it, or the full
  filepath to the conda executable. You can also set the option
  "reticulate.conda_binary" or \`Sys.setenv()\` "RETICULATE_CONDA" to
  tell reticulate where to look.

- force_miniconda:

  force reinstallation of miniconda

- force_environment:

  force reinstallation of the giotto environment

- verbose:

  be verbose

- packages_to_install:

  python modules (packages) to install for Giotto.

## Value

installs a giotto environment using the reticulate miniconda system

## Details

This function will install a local conda environment using the miniconda
system as implemented by reticulate. Which contains ONTraC and a set of
python packages that Giotto may often use.

## Examples

``` r
installGiottoONTraCEnvironment()
```
