## UI module
chamameUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        # Downlod morphorogical analysis data
          download_tsv_dataUI(ns("dl_analysed_data"), "DL analysed data (tsv)"),
      ),

      mainPanel(
        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          reactable::reactableOutput(ns("table")),
        ),
      ),
    )
  )
}

## Server module
chamameServer <- function(id, data_in){
  moduleServer(id, function(input, output, session){

    # Run moranajp_all
    chamame <- reactive({
      text_col <- colnames(data_in())[1]
      col_lang <- "jp"
  #       col_lang <- input$lang
  # print(data_in); print(text_col); print(col_lang)  # for debug
      data_in() %>%
        moranajp::moranajp_all(method = "chamame", text_col = text_col, col_lang = col_lang) %>%
          moranajp::add_sentence_no() %>%
          dplyr::filter(stringr::str_length(.data[[moranajp::unescape_utf("\\u539f\\u5f62")]]) > 0)
    })

    # Show table
    output$table <- reactable::renderReactable({
      reactable::reactable(chamame(), resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Download analysed data
    download_tsv_dataServer("dl_analysed_data", chamame(), "chamame")

    # Return value
  # printx(chamame)
    chamame

  })
}
