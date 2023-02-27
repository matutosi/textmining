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
  #   chamame <- reactive({ chamameServer(text()) })

  # # # clean up # # #
  #   clean_up <- reactive({ clean_up(chamame()) })

  # # # Bigram # # #
  #   bigramServer(clean_up())

}
  # file_upload()
  # moranajp::chamame()
  # moranajp::clean_up()
  # moranajp::bigram()       関数名は正しい?
  # moranajp::draw_bigram() 関数名は正しい?
