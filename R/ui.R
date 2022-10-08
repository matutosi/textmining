  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # # # # # # # # # # # # # # # # 
  # 
  #      ANALYZED data
  # 
  # # # # # # # # # # # # # # # # # # 

  # # # Data load # # #
  tabPanel("Read ALANYZED data",
    tags$h3("1. Prepare tokenized data using https://chamame.ninjal.ac.jp/ (download csv data with UTF-8.)"),
    tags$h3("2. Select TWO columns."),
    tags$h4("First: word column, Second: POS (Position Of Speech) column. (Usually OK in default settings)"),
    load_dataUI("load_analyzed_data")
  ),

  # # # Bigram # # #
  tabPanel("Bigram (analyzed data)",
    bigramUI("bigram_analyzed")
  ),


  # # # # # # # # # # # # # # # # # # 
  # 
  #      RAW data
  # 
  # # # # # # # # # # # # # # # # # # 

  # # # Data load # # #
  tabPanel("Read RAW data",
    tags$h3("Select ONE column (text)."),
    load_dataUI("load_raw_data")
  ),

  # # # MeCab # # #
  tabPanel("MeCab",
    mecabUI("mecab_local")
  ),

  # # Bigram # # #
  tabPanel("Bigram (raw data)",
    bigramUI("bigram_raw")
  ),

)
