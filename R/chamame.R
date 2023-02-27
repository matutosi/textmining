## UI module
chamameUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        selectInput(ns("lang"), "Select colname language", choices = c("en", "jp")),
  #         selectInput(ns("group"), "group", choices = character(0)),
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
chamameServer <- function(id, data_in){
  moduleServer(id, function(input, output, session){

    # Update
  #     observeEvent(data_in, {
  #       updateSelectInput(session, "group", choices = colnames(data_in))
  #     })

  #    group_col <- colnames(data_in)[2]
   col_lang <- input$lang

    # Run moranajp_all
    chamame <- reactive({
      text_col <- colnames(data_in)[1]
      data_in %>%
        moranajp::moranajp_all(method = "chamame", text_col = text_col, col_lang = col_lang)
    })

    # Show table
    output$table <- renderReactable({
      reactable::reactable(chamame(), resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Return
    chamame

  })
}
