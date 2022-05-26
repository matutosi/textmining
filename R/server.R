  # https://matutosi.shinyapps.io/ecanvis/
function(input, output, session){

  # # # ANALYZED daata # # #
  data_in <- load_dataServer("load_analyzed_data", example_data = example_data_analyzed())


  # # # RAW daata # # #
  data_in <- load_dataServer("load_raw_data", example_data = example_data_raw())




  # # # Bigram # # #
  bigramServer("bigram", data_in())


}
