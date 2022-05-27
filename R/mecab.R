## UI module
mecabUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        textInput(ns("bin_dir"), "Directory of MeCab bin", value = "d:/pf/mecab/bin"),
        selectInput(ns("iconv"), "Convert encoding of MeCab output", choices = c("CP932_UTF-8", "", "EUC_UTF-8")),
      ),

      mainPanel(
        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          reactableOutput(ns("table")),
        ),
      ),

    )
  )
}

## Server module
mecabServer <- function(id, data_in){
  moduleServer(id, function(input, output, session){

    # Run moranajp_all
    mecab <- reactive({
      bin_dir  <- input$bin_dir
      text_col <- colnames(data_in)[1]
      iconv    <- input$iconv

      data_in %>%
        moranajp::moranajp_all(bin_dir = bin_dir, text_col = text_col, iconv = iconv) %>%
        dplyr::select(term = 9, pos0 = 3, pos1 = 4)
    })

    # Show table
    output$table <- renderReactable({
      reactable::reactable(mecab(), resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Return
    reactive({ mecab() }) 

  })
}
