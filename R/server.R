  # https://matutosi.shinyapps.io/ecanvis/
function(input, output, session){

  # # # # # # # # # # # # # # # # # # 
  # 
  #  Ver. 2
  # 
  # # # # # # # # # # # # # # # # # # 

  # # # Data load # # #
  text <- reactive({ load_textServer("load_text", example_data = example_text()) })

  # # # moranajp # # #
  chamame <- reactive({ chamameServer("mecab_local", raw_data()) })

  # # # cleaning # # #
  clean_up <- reactive({ clean_up(chamame()) })

  # # # Bigram # # #
  bigramServer("bigram", clean_up())

}
