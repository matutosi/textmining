## Example data raw
example_data_raw <- function() {
  readr::read_delim("data/review.txt")
}
## Example data review
example_data_analyzed <- function() {
  col_types <- stringr::str_c(c(rep("c", 13), "_"), collapse = "")
  readr::read_csv("data/review.csv", col_types = col_types)
}

## UI module
load_dataUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(

        # Instruction
        tags$ol(
          tags$li('Select "Use example data" or "Upload file"'),
          tags$li('Select column to use bigram'),
        ),

        # Example or upload file
        fileInput(ns("file"), "upload file"),
        checkboxInput(ns("file_s_jis"), "Encoding: S-JIS (CP932) JP Windows", value = FALSE),
        tags$hr(),
        checkboxInput(ns("use_example"), "Use example data", value = TRUE),
        tags$hr(),

        # Select column
        selectInput(ns("select_col"), "Select column",
          choices = character(0), multiple = TRUE),

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
load_dataServer <- function(id, example_data){
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
          example_data
        } else {
          req(input$file)
          try(
            readr::read_csv(uploaded_file()$datapath, locale = locale, show_col_types = FALSE)
  #             readr::read_txv(uploaded_file()$datapath, locale = locale, show_col_types = FALSE)
          )
        }
    if(inherits(data_in, "try-error")){
      data_in <- tibble::tibble("Select correct file encoding" = "")
    }
    data_in
    })


    # # # Update selectInput # # #
    observeEvent(c(data_in(), input$use_example), {
      choices <- colnames(data_in())
      selected <-
        if(length(choices) <5  ) choices[1]
        else                     choices[c(12, 6)]
      updateSelectInput(session, "select_col", choices = choices, selected = selected)
    })


    # Download example
    output$download_example <-
      renderUI("Example data: T. MATSUMURA et. al 2014.
        Vegetation Science, 31, 193-218.
        doi: 10.15031/vegsci.31.193, analyzed by https://chamame.ninjal.ac.jp/")
      filename <- "example_data.csv"
    output$dl_example_data <- downloadHandler(
      filename = filename,
      content  = function(file) { readr::write_csv(example_data, file) }
    )

    # Show table
    output$table <- renderReactable({
      reactable::reactable(dplyr::relocate(data_in(), any_of(input$select_col)),
                           resizable = TRUE, filterable = TRUE, searchable = TRUE)
    })

    # Return data
      dplyr::select(data_in(), input$select_col)
  #     reactive({
  #       dplyr::select(data_in(), input$select_col)
  #     })

  })
}
