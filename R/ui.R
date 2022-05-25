  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # Data load # # #
  tabPanel("Read data",
    data_loadUI("data_load", )
  ),


  # # # Bigram # # #
  #   tabPanel("Bigram network",
  #     UI("bigram")
  #   ),

)
