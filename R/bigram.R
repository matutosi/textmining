## UI module
bigramUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(

  #         selectInput(ns("chap"), "chap", choices = 1:4),
        sliderInput(ns("detail_x"), "X range of detail plot", value = c(-5, 5), min = -20, max = 20, step = 0.5),
        sliderInput(ns("detail_y"), "Y range of detail plot", value = c(-5, 5), min = -20, max = 20, step = 0.5),

        checkboxInput(ns("show_axis"), "Show axis", value = TRUE),

        numericInput(ns("rand_seed"), "Seed of random number generation", value = 12, min = 1, max = 100),
        sliderInput(ns("threshold"), "Number of bigram for plot", value = 100, min = 50, max = 200),

        colourInput(ns("arrow_col"),  "Arrow colour",  value = "darkgreen"),
        colourInput(ns("circle_col"), "Circle colour", value = "skyblue"),

        sliderInput(ns("arrow_size"),  "Arrow_size",  value = 4, min = 1, max = 10),
        sliderInput(ns("circle_size"), "Circle size", value = 5, min = 1, max = 10),
        sliderInput(ns("text_size"),   "Text size",   value = 5, min = 1, max = 10),
  # use only in shiny.io
  #         selectInput(ns("font"), "Font", 
  #           choices = c("IPAexGothic", "Source Han Sans", "Noto Sans CJK JP", "SetoFont", 
  #                       "IPAexMincho", "Source Han Serif", "Noto Serif CJK JP")),


        download_tsv_dataUI(ns("download_bigram_data"), "DL bigram data"),

      ),

      mainPanel(

        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          plotOutput(ns("bigram_network_detail"))
        ),

        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          plotOutput(ns("bigram_network"))
        ),

       reactableOutput(ns("table")),

      ),

    )
  )
}

## Server module
bigramServer <- function(id, data_in){
  moduleServer(id, function(input, output, session){

    # bigram
    bigram <- reactive({
      moranajp::bigram(data_in)
    })

    # Show table
    output$table <- renderReactable({
      req(bigram())
      bigram() %>%
        dplyr::select(word_1, word_2, freq) %>% 
        reactable::reactable(resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Download bigram data
    download_tsv_dataServer("download_bigram_data", bigram(), "bigram")

    # word frequency
    freq <- reactive({
      moranajp::word_freq(data_in, bigram_net())
  })

    # bigram network
    bigram_net <- reactive({
      moranajp::bigram_net(bigram(), rand_seed = input$rand_seed, threshold = input$threshold)
    })


    # plot
    bigram_network_raw <- reactive({
      req(bigram_net())
      # use only in shiny.io
      #       font_family <- input$font
      font_family <- if(stringr::str_detect(Sys.getenv(c("OS")), "Windows")){
        # "Yu Mincho"
        # "Noto Sans CJK JP"
        # "Noto Serif CJK JP"
        #         ""
        "Meiryo UI"
      } else {
        "HiraKakuPro-W3"
      }
  # update_geom_defaults("text", list(family = "Yu Gothic UI"))
  # update_geom_defaults("label", list(family = "Yu Gothic UI"))

      bigram_net() %>%
        moranajp::bigram_network_plot(
          freq = freq(),
          arrow_col   = input$arrow_col,
          circle_col  = input$circle_col,
          arrow_size  = input$arrow_size,
          circle_size = input$circle_size,
          text_size   = input$text_size,
          font_family = font_family)
    })

    bigram_network_detail <- reactive({
      bigram_network_raw() + 
        scale_x_continuous(limits = input$detail_x) + 
        scale_y_continuous(limits = input$detail_y)
    })

    bigram_network_detail_noscale <- reactive({
      bigram_network_raw() + 
        scale_x_continuous(breaks = NULL, limits = input$detail_x) + 
        scale_y_continuous(breaks = NULL, limits = input$detail_y)
    })

    bigram_network_raw_noscale <- reactive({
      bigram_network_raw() +
        scale_x_continuous(breaks = NULL) + 
        scale_y_continuous(breaks = NULL)
    })

    # Render
    output$bigram_network_detail <- renderPlot(res = 96, {
        if(input$show_axis) bigram_network_detail()
        else                bigram_network_detail_noscale()
      })
    output$bigram_network <- renderPlot(res = 96, {
        if(input$show_axis) bigram_network_raw()
        else                bigram_network_raw_noscale()
      })

  })
}
