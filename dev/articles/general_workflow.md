# A general Giotto workflow

Most spatial analyses share the same core steps, whatever the
technology: quality control, normalization, dimension reduction and
clustering, followed by spatial analyses such as spatially variable
genes. How the data are measured changes a few of these steps, so the
workflow is shown twice, each on a small dataset that runs in about ten
seconds.

|  | Grid and spot-based | In situ imaging-based |
|----|----|----|
| **Technologies** | Visium, Visium HD, Stereo-seq | MERSCOPE, CosMx, Xenium |
| **What is measured** | Counts per capture spot or bin, which can hold several cells | Individual transcripts and segmented cell outlines |
| **Steps specific to the data** | Spot quality on the tissue image; cell type scores per spot | Counting transcripts into cells; cell area and negative control probes; neighbouring cell types |
| **Example dataset** | Visium mouse brain, 624 spots | MERSCOPE mouse brain, 498 cells |
| **Tutorial** | [**Grid workflow**](https://giottosuite.com/dev/articles/general_workflow_grid.md) | [**In situ workflow**](https://giottosuite.com/dev/articles/general_workflow_insitu.md) |

Both tutorials follow the same steps, in the same order:

1.  Load the data
2.  Quality control and filtering
3.  Normalization (and highly variable genes for whole-transcriptome
    data)
4.  Dimension reduction: PCA, a nearest neighbour network and UMAP
5.  Leiden clustering
6.  Marker genes per cluster
7.  Two spatial analyses
8.  Scale up: links to the same steps on full datasets with GiottoDisk

To start from your own data, see [object
creation](https://giottosuite.com/dev/articles/object_creation.md) and
the [example datasets](https://giottosuite.com/dev/articles/datasets.md)
for your technology.
