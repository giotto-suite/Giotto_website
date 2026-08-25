# runONTraCV1

run ONTraC

## Usage

``` r
runONTraCV1(
  ONTraC_input,
  dataset,
  preprocessing_dir,
  GNN_dir,
  NTScore_dir,
  n_cpu = 4L,
  n_neighbors = 50L,
  n_local = 20L,
  device = c("cpu", "cuda"),
  epochs = 1000L,
  patience = 100L,
  min_delta = 0.001,
  min_epochs = 50L,
  batch_size = 0L,
  seed = 42L,
  lr = 0.03,
  hidden_feats = 4L,
  k = 6L,
  modularity_loss_weight = 0.3,
  purity_loss_weight = 300,
  regularization_loss_weight = 0.1,
  beta = 0.03,
  python_path = "giotto_ontrac_env"
)
```

## Arguments

- dataset:

  the path to the input data file

- preprocessing_dir:

  the directory to save the preprocessing results

- GNN_dir:

  the directory to save the GNN results

- NTScore_dir:

  the directory to save the NTScore results

- n_cpu:

  the number of CPUs used for niche network constructing. Default is 4L

- n_neighbors:

  the number of neighbors used for ONTraC in niche network construction.
  Default is 50L

- n_local:

  the index of local neighbor used for ONTraC in niche network
  construction for normalization. Default is 20L

- device:

  the device used for ONTraC running GNN model. Default is "cpu"

- epochs:

  the maximum number of epochs for model training. Default is 1000L

- patience:

  the number of epochs wait for better result. Default is 100L

- min_delta:

  the minimum change of loss to be considered as improvement. Default is
  0.001

- min_epochs:

  the minimum number of epochs to train. Default is 50L

- batch_size:

  the batch size for training. Default is 0L for whole dataset

- seed:

  the random seed for reproducibility. Default is 42L

- lr:

  the learning rate for training. Default is 0.03

- hidden_feats:

  the number of hidden features for GNN model. Default is 4L

- k:

  the number of neighbors for GNN model. Default is 6L

- modularity_loss_weight:

  the weight of modularity loss. Default is 0.3

- purity_loss_weight:

  the weight of purity loss. Default is 300.0

- regularization_loss_weight:

  the weight of regularization loss. Default is 0.1

- beta:

  the weight of entropy loss. Default is 0.03

- python_path, :

  path to python executable within a conda/miniconda environment.
  Default is "giotto_ontrac_env"

## Value

none

## Details

This function runs ONTraC

## Examples

``` r
runONTraCV1(
    dataset = "ONTraC_dataset_input.csv",
    preprocessing_dir = "preprocessing_dir",
    GNN_dir = "GNN_dir",
    NTScore_dir = "NTScore_dir",
    envname = "giotto_ontrac_env"
)
```
