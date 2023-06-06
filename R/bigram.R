## UI module
bigramUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(

        sliderInput(ns("detail_x"), "X range of detail plot", value = c(-5, 5), min = -20, max = 20, step = 0.5),
        sliderInput(ns("detail_y"), "Y range of detail plot", value = c(-5, 5), min = -20, max = 20, step = 0.5),

        checkboxInput(ns("show_axis"), "Show axis", value = TRUE),

        numericInput(ns("rand_seed"), "Seed of random number generation", value = 12, min = 1, max = 100),
        sliderInput(ns("threshold"), "Number of bigram for plot", value = 100, min = 50, max = 200),

        colourpicker::colourInput(ns("arrow_col"),  "Arrow colour",  value = "darkgreen"),
        colourpicker::colourInput(ns("circle_col"), "Circle colour", value = "skyblue"),

        sliderInput(ns("arrow_size"),  "Arrow_size",  value = 4, min = 1, max = 10),
        sliderInput(ns("circle_size"), "Circle size", value = 5, min = 1, max = 10),
        sliderInput(ns("text_size"),   "Text size",   value = 5, min = 1, max = 10),

        selectInput(ns("font"), "Font", choices = font_choices),

        download_tsv_dataUI(ns("dl_bigram"), "DL bigram data (tsv)"),

      ),

      mainPanel(

        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          plotOutput(ns("big_net_detail"))
        ),

        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          plotOutput(ns("big_net"))
        ),

       reactable::reactableOutput(ns("table")),

      ),

    )
  )
}

## Server module
bigramServer <- function(id, data_chamame){
  moduleServer(id, function(input, output, session){

    # bigram
    big <- reactive({
      moranajp::bigram(data_chamame())
    })

    # Show table
    output$table <- reactable::renderReactable({
      req(big())
      big() %>%
        dplyr::select(word_1, word_2, freq) %>% 
        reactable::reactable(resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Download bigram data
    download_tsv_dataServer("dl_bigram", big(), "bigram")

    # word frequency
    freq <- reactive({
      moranajp::word_freq(data_chamame(), big_net())
    })

    # bigram network
    big_net <- reactive({
      moranajp::bigram_network(big(), rand_seed = input$rand_seed, threshold = input$threshold)
    })

    # plot
    big_net_raw <- reactive({
      req(big_net())
      font_family <- input$font

      big_net() %>%
        moranajp::bigram_network_plot(
          freq = freq(),
          arrow_col   = input$arrow_col,
          circle_col  = input$circle_col,
          arrow_size  = input$arrow_size,
          circle_size = input$circle_size,
          text_size   = input$text_size,
          font_family = font_family)
    })

    big_net_detail <- reactive({
      big_net_raw() + 
        ggplot2::scale_x_continuous(limits = input$detail_x) + 
        ggplot2::scale_y_continuous(limits = input$detail_y)
    })

    big_net_detail_noscale <- reactive({
      big_net_raw() + 
        ggplot2::scale_x_continuous(breaks = NULL, limits = input$detail_x) + 
        ggplot2::scale_y_continuous(breaks = NULL, limits = input$detail_y)
    })

    big_net_raw_noscale <- reactive({
      big_net_raw() +
        ggplot2::scale_x_continuous(breaks = NULL) + 
        ggplot2::scale_y_continuous(breaks = NULL)
    })

    # Render
    output$big_net_detail <- renderPlot(res = 96, {
        if(input$show_axis) big_net_detail()
        else                big_net_detail_noscale()
      })
    output$big_net <- renderPlot(res = 96, {
        if(input$show_axis) big_net_raw()
        else                big_net_raw_noscale()
      })

  })
}
