
# Giotto Suite <img src="man/figures/GiottoLogo.png" align="right" alt="" width="160" />

<!-- badges: start -->
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://tlo.mit.edu/understand-ip/exploring-mit-open-source-license-comprehensive-guide)
![Last Commit](https://badgen.net/github/last-commit/giotto-suite/Giotto/suite)
![Commits Since Latest](https://img.shields.io/github/commits-since/giotto-suite/Giotto/latest/suite)
[![R-CMD-check](https://github.com/giotto-suite/Giotto/actions/workflows/main_check.yaml/badge.svg?branch=suite)](https://github.com/giotto-suite/Giotto/actions/workflows/main_check.yaml)
<!-- badges: end -->

Giotto Suite processes, analyzes and visualizes **spatial multi-omics data at all scales and resolutions**. It works with virtually any spatial technology: *in situ* hybridization, sequencing and imaging-based proteomics, in 2D or 3D, from subcellular to multi-cell resolution.

- **Scalable with GiottoDisk:** datasets larger than memory stay on disk, from ingest to analysis. See the [ecosystem](articles/ecosystem.html).
- **Interactive with GiottoLens:** explore every cell and transcript at full resolution, and send selections back to R for analysis. See [GiottoLens](articles/giottolens.html).
- **Faster spatial analysis:** optional compiled backends speed up matrix maths, spatial joins and cell type motif counting.
- **Interoperability (work in progress):** move data between Giotto and AnnData, Seurat, SpatialExperiment and SpatialData.

## Start here

<div class="gallery">
<a class="tile" href="articles/installation.html">
<strong>1 · Install</strong>
Install Giotto Suite in a few lines.
</a>
<a class="tile" href="articles/general_workflow.html">
<strong>2 · Learn the workflow</strong>
The end-to-end path from raw data to a spatial result.
</a>
<a class="tile" href="articles/datasets.html">
<strong>3 · Find your platform</strong>
Worked examples for Xenium, CosMx, Visium, Stereo-seq and more.
</a>
<a class="tile" href="articles/tutorials.html">
<strong>4 · Find your analysis</strong>
Tutorials for each analysis step, filterable by topic.
</a>
<a class="tile" href="reference/index.html">
<strong>5 · Look up a function</strong>
Every Giotto function, grouped by purpose.
</a>
</div>

New to spatial omics? Start with the [Giotto object](articles/object_creation.html) — it is the structure everything else operates on.

## More to explore

- **[News](news/index.html):** the changelog for every Giotto release, plus recordings of previous presentations.
- **[Contributing](articles/index.html#contributing):** submitting a pull request, the Giotto code style, writing tutorials for this website.
- **[Discussions](https://github.com/giotto-suite/Giotto/discussions):** questions and ideas from the Giotto community.

## Giotto Workshop 2024

Recordings of our 3-day workshop, with the [materials in bookdown format](https://giotto-suite.github.io/giotto_workshop_2024/).

[![Giotto Workshop 2024 recordings](articles/images/presentations/giottoworkshop2024.png){.align-center}](https://www.youtube.com/playlist?list=PL48rCHQx71I1ZptEotKvvCYRliGrqVXLW)


## References

- [Jiaji George Chen, Joselyn Cristina Chávez-Fuentes, et al. Giotto Suite: a multiscale and technology-agnostic spatial multiomics analysis ecosystem. Nature Methods (2025)](https://www.nature.com/articles/s41592-025-02817-w)
- [Dries, R., Zhu, Q. et al. Giotto: a toolbox for integrative analysis and visualization of spatial expression data. Genome Biology (2021).](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-021-02286-2)
- [Dries, R., Chen, J. et al. Advances in spatial transcriptomic data analysis. Genome Research (2021).](https://genome.cshlp.org/content/31/10/1706.long)
- [Del Rossi, N., Chen, J. et al. Analyzing Spatial Transcriptomics Data Using Giotto. Current Protocols (2022).](https://currentprotocols.onlinelibrary.wiley.com/doi/abs/10.1002/cpz1.405)

## Acknowledgements

This software project was supported in part by the [Essential Open Source Software for Science (EOSS) program](https://czi.co/EOSS) at [Chan Zuckerberg Initiative](https://chanzuckerberg.com/).

[![CZI's Essential Open Source Software for Science](https://chanzuckerberg.github.io/open-science/badges/CZI-EOSS.svg)](https://czi.co/EOSS)

