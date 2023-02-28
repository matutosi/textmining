  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # # # # # # # # # # # # # # # # 
  # 
  #      ANALYZED data
  # 
  # # # # # # # # # # # # # # # # # # 

  # # # Data load # # #
  tabPanel("Read text",
    tags$h3("Select ONE column (text)."),
    load_dataUI("load_text"),
  ),

  # # # chamame # # #
  tabPanel("Chamame",
    chamameUI("chamame")
  ),

  # # Bigram # # #
  tabPanel("Bigram (raw data)",
    bigramUI("bigram_raw")
  ),

)
