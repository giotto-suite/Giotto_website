
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- This line is from RStudio -->

# Giotto Suite <img src="man/figures/GiottoLogo.png" align="right" alt="" width="160" />

<!-- badges: start -->
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://tlo.mit.edu/understand-ip/exploring-mit-open-source-license-comprehensive-guide)
![Last Commit](https://badgen.net/github/last-commit/giotto-suite/Giotto/suite)
![Commits Since Latest](https://img.shields.io/github/commits-since/giotto-suite/Giotto/latest/suite)
[![R-CMD-check](https://github.com/giotto-suite/Giotto/actions/workflows/main_check.yaml/badge.svg?branch=suite)](https://github.com/giotto-suite/Giotto/actions/workflows/main_check.yaml)
<!-- badges: end -->

Giotto Suite is a major upgrade to the Giotto package that provides tools to process, analyze and visualize **spatial multi-omics data at all scales and multiple resolutions**. The underlying framework is generalizable to virtually all current and emerging spatial technologies. Our Giotto Suite prototype pipeline is generally applicable on various different datasets, such as those created by state-of-the-art spatial technologies, including *in situ* hybridization, sequencing, and imaging-based multiplexing/proteomics. These technologies differ in terms of resolution (subcellular, single cell or multiple cells), spatial dimension (2D vs 3D), molecular modality (protein, RNA, DNA, …), and throughput (number of cells and analytes).

## Start here

<div class="gallery">
<a class="tile" href="articles/installation.html">
<strong>1 · Install</strong>
Set up Giotto Suite and its Python environment.
</a>
<a class="tile" href="articles/general_workflow.html">
<strong>2 · Learn the workflow</strong>
The end-to-end path from raw data to a spatial result.
</a>
<a class="tile" href="articles/index.html#in-situ-methods">
<strong>3 · Find your platform</strong>
Worked examples for Xenium, CosMx, Visium, Stereo-seq and more.
</a>
<a class="tile" href="reference/index.html">
<strong>4 · Look up a function</strong>
Every Giotto function, grouped by purpose.
</a>
</div>

New to spatial omics? Start with the [Giotto object](articles/object_creation.html) — it is the structure everything else operates on.

## Installation

### Local installation

To install Giotto suite, please see our [installation page](articles/installation.html)

Visit the Giotto [Discussions](https://github.com/giotto-suite/Giotto/discussions) page for more information.

### Containers

If you prefer to skip the installation process, check the tutorials for using Giotto Suite with our [Docker](articles/docker.html) and [Singularity](articles/singularity.html) containers.

## Finding your way around

- **[Get started](articles/index.html#get-started):** the Giotto object, the Giotto ecosystem, configuration, and installation FAQs.
- **[Documentation](reference/index.html):** all Giotto functions grouped by their purpose (helpers, getters & setters, visualization, …).
- **[Examples](articles/index.html#in-situ-methods):** end-to-end examples for different technologies and datasets.
- **[Tutorials](articles/index.html#pre-processing):** working with Giotto — analysis, visualization, running on the cloud, and more.
- **[News](news/index.html):** the changelog for every Giotto release, plus recordings of previous presentations.
- **[Contributing](articles/index.html#contributing):** submitting a pull request, the Giotto code style, writing tutorials for this website.

## Giotto Workshop 2024

Take a look at our 3-day workshop recordings. The materials in bookdown format are available [here](https://giotto-suite.github.io/giotto_workshop_2024/)

[![](articles/images/presentations/giottoworkshop2024.png){.align-center}](https://www.youtube.com/playlist?list=PL48rCHQx71I1ZptEotKvvCYRliGrqVXLW)


## References

- [Jiaji George Chen, Joselyn Cristina Chávez-Fuentes, et al. Giotto Suite: a multiscale and technology-agnostic spatial multiomics analysis ecosystem. Nature Methods (2025)](https://www.nature.com/articles/s41592-025-02817-w)
- [Dries, R., Zhu, Q. et al. Giotto: a toolbox for integrative analysis and visualization of spatial expression data. Genome Biology (2021).](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-021-02286-2)
- [Dries, R., Chen, J. et al. Advances in spatial transcriptomic data analysis. Genome Research (2021).](https://genome.cshlp.org/content/31/10/1706.long)
- [Del Rossi, N., Chen, J. et al. Analyzing Spatial Transcriptomics Data Using Giotto. Current Protocols (2022).](https://currentprotocols.onlinelibrary.wiley.com/doi/abs/10.1002/cpz1.405)

## Acknowledgements

This software project was supported in part by the [Essential Open Source Software for Science (EOSS) program](https://czi.co/EOSS) at [Chan Zuckerberg Initiative](https://chanzuckerberg.com/).

[![CZI's Essential Open Source Software for Science](https://chanzuckerberg.github.io/open-science/badges/CZI-EOSS.svg)](https://czi.co/EOSS)

