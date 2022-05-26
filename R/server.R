  # https://matutosi.shinyapps.io/ecanvis/
function(input, output, session){

  # # # ANALYZED daata # # #
  analayzed_data <- 
    load_dataServer("load_analyzed_data", example_data = example_data_analyzed())

  # # # RAW daata # # #
  raw_data <- 
    load_dataServer("load_raw_data", example_data = example_data_raw())

  # # # moranajp # # #
  mecabServer("mecab", raw_data())


  # # # Bigram # # #
  bigramServer("bigram", analayzed_data())


}
