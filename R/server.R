  # https://matutosi.shinyapps.io/textmining2/
function(input, output, session){

  # # # # # # # # # # # # # # # # # # # #
  #
  #  Ver. 3
  #
  # # # # # # # # # # # # # # # # # # # #

  # # # Data load # # #
  text <- uploaded_fileServer(id = "text", 
            example_data = example_text())

  # # # chamame # # #
  chamame <- chamameServer(id = "chamame", text)

  # # # stop_words # # #
  stop_words_1 <- uploaded_fileServer(id = "stop_words", 
                    example_data = example_stop_words())
  stop_words_2 <- 
    reactive({
  #       req(input$stop_words_2)
      input$stop_words_2
    })

  # # # synonym # # #
  synonym <- uploaded_fileServer(id = "synonym", 
               example_data = example_synonym())

  # # # cleanup # # #
  cleanup <- cleanupServer(id = "cleanup", 
               chamame = chamame, 
               stop_words_1 = stop_words_1, 
               stop_words_2 = stop_words_2, 
               synonym = synonym)

  # # # Bigram # # #
  #   bigramServer(id = "bigram", chamame)
  bigramServer(id = "bigram", cleanup)

}
