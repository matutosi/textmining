  # https://matutosi.shinyapps.io/ecanvis/
function(input, output, session){

  # # # # # # # # # # # # # # # # # # 
  # 
  #      ANALYZED data
  # 
  # # # # # # # # # # # # # # # # # # 

  # # # Data load # # #
  #   text <- reactive({ load_dataServer("load_text", example_data = example_text()) })
  text <- load_dataServer("load_text", example_data = example_text())

  # # # moranajp # # #
  chamame <- chamameServer("chamame", text)

  # # # Bigram # # #
  bigramServer("bigram", chamame)

}
