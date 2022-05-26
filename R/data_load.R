## Example data
data_example <- function() {
  data(neko, package = "moranajp")
  neko %>%
    dplyr::mutate(text=stringi::stri_unescape_unicode(text)) %>%
    dplyr::mutate(cols=1:nrow(.))
}

## UI module
data_loadUI <- function(id, label = "Upload file") {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(

        # Instruction
        tags$ol(
          tags$li('Select "Use example data" or "Upload file"'),
          tags$li('Specify variable as text input')
        ),

        # Example or upload file
        fileInput(ns("file"), label),
        checkboxInput(ns("file_s_jis"), "Encoding: S-JIS (CP932) JP Windows", value = FALSE),
        tags$hr(),
        checkboxInput(ns("use_example"), "Use example data"),
  #         checkboxInput(ns("use_example"), "Use example data", value = TRUE),

        # select variable
        selectInput(ns("text"), "Text: ", choices = character(0)),

      # Downlod example
        tags$hr(),
          htmlOutput(ns("download_example")),
          downloadButton(ns("dl_example_data"), "Downlaod example data"),
        ),

      mainPanel(
        reactableOutput(ns("table")),
      )

    )
  )
}

## Server module
data_loadServer <- function(id){
  moduleServer(id, function(input, output, session){

    # File name to upload
    uploaded_file <- reactive({
      req(input$file)
      input$file
    })

    data_in <- reactive({
      locale <- if(input$file_s_jis) readr::locale(encoding = "CP932")
        else                         readr::default_locale()
      data_in <- 
        if(input$use_example){
          data_example()
        } else {
          req(input$file)
          try(
            readr::read_delim(uploaded_file()$datapath, locale = locale, show_col_types = FALSE)
          )
        }
    if(inherits(data_in, "try-error")) data_in <- tibble::tibble("Select correct file encoding" = "")
    data_in
    })

    # # # Input data # # #
    observeEvent(data_in(), {
      req(data_in())
      choices <- colnames(data_in())
      updateSelectInput(session, "text", choices = choices)
    })

    # Download example
    output$download_example <-
      renderUI("Example data is generated with data dune and dune.env in library vegan.")
    output$dl_example_data = downloadHandler(
      filename = "example_data.tsv",
      content  = function(file) { readr::write_tsv(data_example(), file) }
    )

    # Show table
    output$table <- renderReactable({
      reactable::reactable(data_in(), resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Return data
    reactive({ list(data = data_in(), text_col = input$text) })

  })
}
