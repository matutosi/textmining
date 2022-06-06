  # https://matutosi.shinyapps.io/ecanvis/
function(input, output, session){

  # # # # # # # # # # # # # # # # # # 
  # 
  #      ANALYZED data
  # 
  # # # # # # # # # # # # # # # # # # 

  # # # Data load # # #
  analayzed_data <- load_dataServer("load_analyzed_data", example_data = example_data_analyzed())

  # # # cleaning # # #
  chamame_res <- reactive({ clean_chamame_2(analayzed_data()) }) 

  # # # Bigram # # #
  bigramServer("bigram_analyzed", chamame_res())


  # # # # # # # # # # # # # # # # # # 
  # 
  #      RAW data
  # 
  # # # # # # # # # # # # # # # # # # 

  # # # Data load # # #
  raw_data <- load_dataServer("load_raw_data", example_data = example_data_raw())

  # # # moranajp # # #
  mecab_local <- mecabServer("mecab_local", raw_data())

  # # # cleaning # # #
  mecab_res <- reactive({ clean_mecab_local_2(mecab_local()) })

  # # # Bigram # # #
  bigramServer("bigram_raw", mecab_res())


}
