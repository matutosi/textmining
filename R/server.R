  # https://matutosi.shinyapps.io/ecanvis/
function(input, output, session){

  # # # # # # # # # # # # # # # # # #
  #
  #  Ver. 2
  #
  # # # # # # # # # # # # # # # # # #

  # # # Data load # # #
  #   text <- reactive({ load_dataServer("load_text", example_data = example_text()) })
  text <- load_dataServer("load_text", example_data = example_text())

  # # # moranajp # # #
  chamame <- chamameServer("chamame", text)

  # # # clean up # # #
  #   clean_up <- reactive({ clean_up(chamame()) })

  # # # Bigram # # #
  bigramServer("bigram", chamame)

}
