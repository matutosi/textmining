## UI module
chamameUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        # Downlod morphorogical analysis data
          download_tsv_dataUI(ns("dl_analysed_data"), "DL analysed data (tsv)"),
      ),
  #         selectInput(ns("lang"), "Select colname language", choices = c("jp", "en")),
  #         selectInput(ns("group"), "group", choices = character(0)),

      mainPanel(
        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          reactableOutput(ns("table")),
        ),
      ),
    )
  )
}

## Server module
chamameServer <- function(id, data_in){
  moduleServer(id, function(input, output, session){

    # Update
  #     observeEvent(data_in, {
  #       updateSelectInput(session, "group", choices = colnames(data_in))
  #     })
  #    group_col <- colnames(data_in)[2]


    # Run moranajp_all
    chamame <- reactive({
      text_col <- colnames(data_in())[1]
      col_lang <- "jp"
  #       col_lang <- input$lang
  # print(data_in); print(text_col); print(col_lang)  # for debug
      data_in() %>%
        moranajp::moranajp_all(method = "chamame", text_col = text_col, col_lang = col_lang) %>%
          moranajp::add_sentence_no() %>%
          dplyr::filter(stringr::str_length(.data[[moranajp::unescape_utf("\\u539f\\u5f62")]]) > 0) %>%
          moranajp::clean_up()
    })

    # Show table
    output$table <- renderReactable({
      reactable::reactable(chamame(), resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Download analysed data
    download_tsv_dataServer("dl_analysed_data", chamame(), "chamame")

    # Return value
  # printx(chamame)
    chamame

  })
}
