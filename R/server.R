  # https://matutosi.shinyapps.io/textmining2/
function(input, output, session){

  # # # # # # # # # # # # # # # # # # # #
  #
  #  Ver. 2
  #
  # # # # # # # # # # # # # # # # # # # #

  # # # # # # test # # # # # # # # # # # #
  #   text <- 
  #     uploaded_fileServer(id = "test", 
  #                         example_data = example_stop_words(), 
  #                         example_description = "this is test module")
  # # # # # # # # # # # # # # # # # # # # #

  # # # Data load # # #
  text <- 
    uploaded_fileServer(id = "text", 
                        example_data = example_text(), 
                        example_description = "Data: T. MATSUMURA et. al 2014. Vegetation Science, 31, 193-218. doi: 10.15031/vegsci.31.193")

  # # # chamame # # #
  chamame <- chamameServer("chamame", text)

  # # # stop_words # # #
  stop_words <- 
    uploaded_fileServer(id = "stop_words", 
                        example_data = example_stop_words(), 
                        example_description = "Upload stop words")

  # # # synonym # # #
  synonym <- 
    uploaded_fileServer(id = "synonym", 
                        example_data = example_synonym(), 
                        example_description = "Upload synonym")

  # # # Bigram # # #
  bigramServer("bigram", chamame)
  #   bigramServer("bigram", chamame, stop_words, synonym)
}
