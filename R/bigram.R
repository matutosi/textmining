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
      data_in %>%
  #         dplyr::filter(chap == input$chap) %>%
        dplyr::group_by(text_id) %>%
        # according to arrow direction in ggplot: "word_2-word_1"
        dplyr::transmute(text_id, word_2 = term, word_1 = dplyr::lag(term), bigram = stringr::str_c(word_2, " - ", word_1)) %>%
        dplyr::ungroup() %>%
        na.omit() %>%
        dplyr::group_by(word_1, word_2) %>%
        dplyr::summarise(freq = dplyr::n()) %>%
        dplyr::ungroup() %>%                     # if keep group, slice do not work
        dplyr::arrange(dplyr::desc(freq))
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
    freq_ratio <- reactive({
      term <- 
        bigram_net() %>%
        igraph::V() %>%
        .$name
      data_in %>%
        dplyr::group_by(term) %>%
        dplyr::tally() %>%
        dplyr::left_join(tibble::tibble(term = term), .) %>%
        .$n %>%
        log() %>%
        round(0) * 2
    })

    # bigram network
    bigram_net <- reactive({
      set.seed(input$rand_seed)
      threshold <- input$threshold
      bigram() %T>%
        { freq_thresh <<- dplyr::slice(., threshold)$freq } %>%
        dplyr::filter(freq > freq_thresh) %>%
        graph_from_data_frame()
    })

    # plot
    bigram_network_raw <- reactive({
      req(bigram_net())

      arrow_size  <- unit(input$arrow_size, 'mm')
      circle_size <- input$circle_size
      text_size   <- input$text_size
  # use only in shiny.io
  #       font_family <- input$font
      font_family <- ""

      bigram_net() %>%
        ggraph(layout = "fr") +        # the most understandable layout
        geom_edge_link(color  = input$arrow_col,  arrow = arrow(length = arrow_size), start_cap = circle(input$arrow_size, 'mm'), end_cap = circle(input$arrow_size, 'mm')) +
        geom_node_point(color = input$circle_col, size = freq_ratio() * circle_size * 0.2) +  # default (5) means 5 * 0.2 = 1
        geom_node_text(aes(label = name), vjust = 1, hjust = 1, size = text_size, family = font_family) +
        ggplot2::theme_bw() + 
        ggplot2::theme(axis.title.x = element_blank(),
                       axis.title.y = element_blank())
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
