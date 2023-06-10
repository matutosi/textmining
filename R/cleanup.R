## UI module
cleanupUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        # Cleanup analysed data
          checkboxInput(ns("use_combine_words"), "Use combine words", value = FALSE),
          checkboxInput(ns("use_stop_words"), "Use stop words", value = TRUE),
          checkboxInput(ns("use_synonym"), "Use synonym", value = TRUE),
          download_tsv_dataUI(ns("dl_cleanuped"), "DL cleanuped data (tsv)"),
      ),

      mainPanel(
        shinycssloaders::withSpinner(type = sample(1:8, 1), color.background = "white",
          reactable::reactableOutput(ns("table")),
        ),
      ),
    )
  )
}

## Server module
cleanupServer <- function(id, chamame, 
                          combine_words_1, combine_words_2, 
                          stop_words_1, stop_words_2, 
                          synonym_1, synonym_2){

  moduleServer(id, function(input, output, session){

  # Run moranajp_all
    cleanup <- reactive({

  # combi_words
      if(input$use_combine_words){
        combi_words <- 
          c(unlist(combine_words_1()),
            strsplit(combine_words_2(), split = "，|,")[[1]],
            "")
      }else{
        combi_words <- ""
      }
  # printx(combi_words) # for debug

  # stop_words
      if(input$use_stop_words){
        stop_words <- 
          c(unlist(stop_words_1()),
            strsplit(stop_words_2(), split = "，|,")[[1]],
            "")
      }else{
        stop_words <- ""
      }
  # printx(stop_words) # for debug

  # synonym
  # synonym_2 <- function(){ "出来る=できる,わかる=分かる"}
      if(input$use_synonym){
        synonym_df <- 
          strsplit(synonym_2(), split = "，|,")[[1]] %>%
            tibble::tibble(from = .) %>%
            tidyr::separate(from, into = c("from", "to"), sep = "=") %>%
            dplyr::bind_rows(synonym_1()) %>%
            dplyr::distinct()
      }else{
        synonym_df <- tibble::tibble()
      }
  #       if(input$use_synonym){
  #         synonym_df <- synonym()
  #       }else{
  #         synonym_df <- tibble::tibble()
  #       }
  # printx(synonym_df) # for debug

      combined <- moranajp::combine_words(chamame(), combi_words)
      moranajp::clean_up(
        combined,
        use_common_data = FALSE,
        add_stop_words = stop_words,
        synonym_df = synonym_df)
    })

    # Show table
    output$table <- reactable::renderReactable({
      reactable::reactable(cleanup(), resizable = TRUE, filterable = TRUE, searchable = TRUE,)
    })

    # Download analysed data
    download_tsv_dataServer("dl_cleanuped", cleanup(), "cleanup")

    # Return value
    cleanup

  })
}
