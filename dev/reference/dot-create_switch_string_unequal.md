# Create switch string unequal

Create switch string unequal

## Usage

``` r
.create_switch_string_unequal(
  num_first = NULL,
  num_second = NULL,
  switch_strs = NULL
)
```

## Arguments

- num_first:

  sorted vector of cluster numbers in the outer for loop

- num_second:

  sorted vector of cluster numbers in the inner for loop

## Value

switch_str, a vector of corresponding cluster numbers in strings

## Details

creates a string in the format c("x_1-y_1", "x_2-y_2"..."x_n, y_m")
Where: x_n is a cluster number from the original spatial unit y_m is a
cluster number from the resized spatial unit n is the number of clusters
in the original spatial unit m is the number of clusters in the new
spatial unit
