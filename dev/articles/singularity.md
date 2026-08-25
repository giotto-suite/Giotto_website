# Singularity container

## 1 Singularity container with bash terminal

You can set up a Singularity container based on the [Giotto Docker
Image](https://hub.docker.com/r/giottopackage/suite) able to run in a
bash environment.

### 1.1 Instructions

Follow these instructions to create your own Singularity and run Giotto:

1.  singularity pull suite.sif docker://giottopackage/suite:v4.2.0 or
    singularity pull suite.sif docker://giottopackage/suite:latest.
    Alternatively, you can also build a sandbox folder: singularity
    build –sandbox suite/ docker://giottopackage/suite:v4.2.0 or
    singularity build –sandbox suite/
    docker://giottopackage/suite:latest
2.  singularity shell suite.sif
3.  R
4.  Run the following **in R**:
    1.  library(Giotto)
5.  Now you can run any analysis with Giotto!
