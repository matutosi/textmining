  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # Data load # # #
  tabPanel("Read ALANYZED data",
    tags$h3("Select TWO columns."),
    tags$h4("First: word column, Second: POS (Position Of Speech) column."),
    load_dataUI("load_analyzed_data")
  ),

  tabPanel("Read RAW data",
    tags$h3("Select ONE column (text)."),
    load_dataUI("load_raw_data")
  ),

  tabPanel("MeCab",
    mecabUI("mecab")
  ),


  # # # Bigram # # #
  tabPanel("Bigram",
    bigramUI("bigram")
  ),

)
