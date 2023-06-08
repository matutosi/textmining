## UI module
upload_fileUI <- function(id, 
                          instruction = "", 
                          use_example = TRUE, 
                          select_column = TRUE, 
                          dl_example = TRUE,
                          example_description = ""){
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(

        # Instruction
        str2li(instruction, ol = TRUE),

        # Upload file
        fileInput(ns("file"), "upload file"),
        checkboxInput(ns("file_s_jis"), "Encoding: S-JIS JP Windows", value = FALSE),

        # Example 
        if(use_example){
          tagList(
            checkboxInput(ns("use_example"), "Use example data", value = use_example),
          )
        }else{
          tagList()
        },

        # Select column
        if(select_column){
          tagList(
            selectInput(ns("select_col"), "Select column", choices = character(0)),
          )
        }else{
          tagList()
        },

        # Downlod example
        if(dl_example){
          download_tsv_dataUI(
            id = ns("dl_example"), 
            label = paste0("DL example of ", id), 
            description = example_description)
        }else{
          tagList()
        },

      ),

      mainPanel(
        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          reactable::reactableOutput(ns("table")),
        )
      )

    )
  )
}

## Server module
uploaded_fileServer <- function(id, example_data = NUL){
  moduleServer(id, function(input, output, session){

    # # # File name to upload # # #
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
            readr::read_tsv(uploaded_file()$datapath, locale = locale, show_col_types = FALSE)
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
        if(length(choices) < 5 ) choices[1]
        else                     choices[c(12, 6)]
      updateSelectInput(session, "select_col", choices = choices, selected = selected)
    })

    # # # Download example # # #
    output$dl_example <- 
      download_tsv_dataServer(id = "dl_example", 
                              data = example_data, 
                              filename = paste0(id, "_example"))

    # # # Show table # # #
    output$table <- reactable::renderReactable({
      reactable::reactable(dplyr::relocate(data_in(), any_of(input$select_col)), resizable = TRUE, filterable = TRUE, searchable = TRUE)
    })

    # # # Selected text # # #
    observeEvent(c(data_in(), input$select_col), {
      if(length(input$select_col) > 0){
        data_in <- reactive({ dplyr::select(data_in(), any_of(input$select_col)) })
      }
    })

  data_in

  })
}
