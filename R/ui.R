  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # # # # # # # # # # # # # # # #
  #
  #  Ver. 2
  #
  # # # # # # # # # # # # # # # # # #

  # # # Data load # # #
  tabPanel("Upload text",
    tags$h3("Select ONE column (text)."),
    upload_fileUI(id = "text",
      instruction = c("Prepare text file", "Updoad the file"), 
      example_description = "Data: T. MATSUMURA et. al 2014. Vegetation Science, 31, 193-218. doi: 10.15031/vegsci.31.193"),
  ),

  # # # chamame # # #
  tabPanel("Chamame",
    chamameUI(id = "chamame")
  ),

  # # # Stop words # # #
  tabPanel("Stop words",
    tags$h3("Input and/or Upload stop words"),
    textInput("stop_words_2", label = "Input stop words separate with ',' or '，'", value = "", placeholder = "例：これ，は,例,です"),
    upload_fileUI(
      id = "stop_words", 
      instruction = c("Prepare stop words file", "Updoad the file"), 
      select_column = FALSE),
  ),

  # # # Synonym # # #
  tabPanel("Synonym",
    tags$h3("Upload synonym"),
    upload_fileUI(
      id = "synonym", 
      instruction = c("Prepare synonym file", "Updoad the file"),
      select_column = FALSE),
  ),

  # # # Synonym # # #
  tabPanel("Cleanup",
    tags$h3("Cleanup"),
    cleanupUI(id = "cleanup"),
  ),

  # # Bigram # # #
  tabPanel("Bigram",
    bigramUI("bigram")
  ),

)
