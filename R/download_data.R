## UI module
download_tsv_dataUI <- function(id, label = "DL file", description = ""){
  ns <- NS(id)
  tagList(
    downloadButton(ns("data_download_tsv"), label),
    tags$p(description),
  )
}

## Server module
download_tsv_dataServer <- function(id, data, filename){
  moduleServer(id, function(input, output, session){
    output$data_download_tsv = downloadHandler(
      filename = paste0(filename, ".tsv"),
      content  = function(file) { readr::write_tsv(data, file) }
    )
  })
}
