# Cell type proximity for spots

Compute cell-cell interactions observed value for internal and external
spots

## Usage

``` r
.cell_proximity_spots_internal(cell_IDs, dwls_values)

.cell_proximity_spots_external(pairs, dwls_values)

.cell_proximity_spots(cell_IDs, pairs_external, dwls_values)
```

## Arguments

- cell_IDs:

  cell_IDs

- dwls_values:

  data.table of cell type enrichment in each spot and multiply by cell
  number in each spot

- pairs:

  data.table of paired spots. Format: cell_ID1, cell_ID2, N

- pairs_external:

  data.table of paired spots. Format: cell_ID1, cell_ID2, N. Passes to
  \`.cell_proximity_spots_external\` \`pairs\` param

## Value

List of cell proximity observed value in data.table format. Columns:
unified_int, type_int, V1, external, internal.

## Functions

- `.cell_proximity_spots_internal()`: Compute cell-cell interactions
  observed value inner each spot

- `.cell_proximity_spots_external()`: Compute cell-cell interactions
  observed value for interacted spots

- `.cell_proximity_spots()`: Wrapper function
