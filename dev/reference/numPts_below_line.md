# numPts_below_line

function to calculate the number of data points below a given line

## Usage

``` r
numPts_below_line(myVector, slope, x)
```

## Arguments

- myVector:

  input sequence of sorted positive values from smallest to greatest

- slope:

  slope to compare

- x:

  location point of the line to compare, integer from 1 to length of
  myVector

## Value

numeric

## Details

This function calculates the number of data points in a sorted sequence
below a line with given slope through a certain point on this sequence.
