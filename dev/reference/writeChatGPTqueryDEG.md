# writeChatGPTqueryDEG

This function writes a query as a .txt file that can be used with
ChatGPT or a similar LLM service to find the most likely cell types
based on the top differential expressed genes (DEGs) between identified
clusters.

## Usage

``` r
writeChatGPTqueryDEG(
  DEG_output,
  top_n_genes = 10,
  tissue_type = "human breast cancer",
  folder_name = getwd(),
  file_name = "chatgpt_query.txt"
)
```

## Arguments

- DEG_output:

  the output format from the differential expression functions

- top_n_genes:

  number of genes for each cluster

- tissue_type:

  tissue type

- folder_name:

  path to the folder where you want to save the .txt file

- file_name:

  name of .txt file

## Value

writes a .txt file to the desired location

## Details

This function does not run any LLM service. It simply creates the .txt
file that can then be used any LLM service (e.g. OpenAI, Gemini, ...)
