## Example data raw
data_example_raw <- function() {
  readr::read_csv("review.txt")
}
## Example data review
data_example_analyzed <- function() {
  col_types <- stringr::str_c(c(rep("c", 13), "_"), collapse = "")
  readr::read_csv("review.csv", col_types = col_types)
}

## UI module
data_loadUI <- function(id, label = "Upload file") {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(

        # Instruction
        tags$ol(
  #           tags$li('Select "Data type"'),
          tags$li('Select "Use example data" or "Upload file"'),
        ),

        # Data type
  #         selectInput(ns("data_type"), "Data type: ", 
  #           choices = c("analyzed (tokenized) data" = "", "analyzed" = "raw")),
  #         tags$hr(),

        # Example or upload file
        fileInput(ns("file"), label),
        checkboxInput(ns("file_s_jis"), "Encoding: S-JIS (CP932) JP Windows", value = FALSE),
        tags$hr(),
        checkboxInput(ns("use_example"), "Use example data", value = TRUE),

        # select variable
  #         selectInput(ns("text"), "Text: ", choices = character(0)),

      # Downlod example
        tags$hr(),
          downloadButton(ns("dl_example_data"), "Downlaod example data"),
          htmlOutput(ns("download_example")),
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
  #           if(input$data_type == "analyzed") {
            data_example_analyzed()
  #         } else {
  #           data_example_raw()
  #         }
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
      renderUI("Example data: T. MATSUMURA et. al 2014. Vegetation Science, 31, 193-218. doi: 10.15031/vegsci.31.193, analyzed by https://chamame.ninjal.ac.jp/")
  #     if(input$data_type == "analyzed"){
      data_example <- data_example_analyzed()
      filename <- "data_example_analyzed.csv"
  #     } else {
  #       data_example <- data_example_raw()
  #       filename <- "data_example_raw.csv"
  #     }
    output$dl_example_data <- downloadHandler(
      filename = filename,
      content  = function(file) { readr::write_csv(data_example, file) }
    )

    # Show table
    output$table <- renderReactable({
      reactable::reactable(data_in(), resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Return data
    reactive({ data_in() })

  })
}
