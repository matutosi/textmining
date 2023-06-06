  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # # # # # # # # # # # # # # # #
  #
  #  Ver. 2
  #
  # # # # # # # # # # # # # # # # # #

  # # # test # # #
  #   tabPanel("test",
  #     tags$h3("test"),
  #     upload_fileUI(id = "test", instruction = c("a", "b")),
  #   ),

  # # # Data load # # #
  tabPanel("Upload text",
    tags$h3("Select ONE column (text)."),
    upload_fileUI(id = "text", instruction = c("Prepare text file", "Updoad the file")),
  #     load_dataUI("load_text"),
  ),

  # # # chamame # # #
  tabPanel("Chamame",
    chamameUI("chamame")
  ),

  # # # Stop words # # #
  tabPanel("Stop words",
    tags$h3("Upload stop words"),
    upload_fileUI(id = "stop_words", instruction = c("Prepare stop words file", "Updoad the file")),
  ),

  # # # Synonym # # #
  tabPanel("Synonym",
    tags$h3("Upload synonym"),
    upload_fileUI(id = "synonym", instruction = c("Prepare synonym file", "Updoad the file")),
  ),

  # # Bigram # # #
  tabPanel("Bigram",
    bigramUI("bigram")
  ),

)
