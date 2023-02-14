  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # # # # # # # # # # # # # # # #
  #
  #  Ver. 2
  #
  # # # # # # # # # # # # # # # # # #

  # # # Data load # # #
  tabPanel("Read text",
    tags$h3("Select ONE column (text)."),
    load_dataUI("load_text")
  ),

  # # # chamame # # #
  tabPanel("Chamame",
    mecabUI("chamame")
  ),

  # # Bigram # # #
  tabPanel("Bigram",
    bigramUI("bigram")
  ),

)

# file_upload()
# moranajp::chamame()
# moranajp::clean_up()
# moranajp::bigram()       関数名は正しい?
# moranajp::draw_bigram() 関数名は正しい?
