# Determine switch string unequal

Determine switch string unequal

## Usage

``` r
.determine_switch_string_unequal(num_orig = NULL, num_new = NULL)
```

## Arguments

- num_orig:

  sorted vector of cluster numbers in the original metadata

- num_new:

  sorted vector of cluster numbers in the new, resized metadata

## Value

switch_str, a vector of corresponding cluster numbers in strings

## Details

determines how to create a string in the format c("x_1-y_1",
"x_2-y_2"..."x_n, y_m") Where: x_n is a cluster number from the original
spatial unit y_m is a cluster number from the resized spatial unit n is
the number of clusters in the original spatial unit m is the number of
clusters in the new spatial unit

Essentially determines iteration order for
.create_switch_string_unequal()
