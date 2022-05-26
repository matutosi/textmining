  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # Data load # # #
  tabPanel("Read ALANYZED data",
    load_dataUI("load_analyzed_data")
  ),

  tabPanel("Read RAW data",
    load_dataUI("load_raw_data")
  ),



  # # # Bigram # # #
  tabPanel("Bigram",
    bigramUI("bigram")
  ),

)
