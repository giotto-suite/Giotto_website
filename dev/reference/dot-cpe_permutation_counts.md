# .cpe_permutation_counts

Vectorized cell-type-pair counting for the observed network and for a
set of node-label permutations.

## Usage

``` r
.cpe_permutation_counts(
  from,
  to,
  codes,
  K,
  number_of_simulations,
  set_seed = TRUE,
  seed_number = 1234
)
```

## Arguments

- from, to:

  integer vectors of 1-based node indices, one entry per (deduplicated,
  undirected) edge.

- codes:

  integer vector of cell-type codes (1..K), one entry per node.

- K:

  integer, number of cell-type levels.

- number_of_simulations:

  number of label permutations.

- set_seed, seed_number:

  seed control.

## Value

list with \`obs\` (integer vector of length K\*K) and \`sim\` (K\*K x
number_of_simulations integer matrix) of pair counts, indexed by
\`(lo - 1) \* K + hi\` for the sorted type pair \`(lo, hi)\`.

## Details

The null model permutes cell-type labels over the \*nodes\* of the
network, so each cell keeps a single label across all of its edges.
Counting is done with \[tabulate()\] over an integer pair key, so no
intermediate edge x simulation table is ever materialized.
