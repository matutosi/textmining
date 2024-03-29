  # https://matutosi.shinyapps.io/textmining/
navbarPage("textmining",

  # # # # # # # # # # # # # # # # # #
  #
  #  Ver. 3
  #
  # # # # # # # # # # # # # # # # # #

  # # # Data load # # #
  tabPanel("Upload text",
    tags$h3("Upload text."),
    upload_fileUI(id = "text",
      instruction = c("Prepare text file", "Updoad the file", "Select ONE column (text)"), 
      example_description = "T. MATSUMURA et. al 2014. Vegetation Science, 31, 193-218. doi: 10.15031/vegsci.31.193"),
  ),

  # # # chamame # # #
  tabPanel("Chamame",
    tags$h3("Analysed with https://chamame.ninjal.ac.jp/"),
    chamameUI(id = "chamame")
  ),

  # # # combine words # # #
  tabPanel("Combine words",
    tags$h3("Input and/or Upload combine words"),
    textInput("combine_words_2", label = "Input words combined with '-' and separated with ',' or '，'", 
              value = "", placeholder = "半-自然,多様-性"),
    upload_fileUI(
      id = "combine_words", 
      instruction = c("Prepare combine words file", "Updoad the file"), 
      example_description = "",
      select_column = FALSE),
  ),

  # # # Stop words # # #
  tabPanel("Stop words",
    tags$h3("Input and/or Upload stop words"),
    textInput("stop_words_2", label = "Input stop words separated with ',' or '，'", value = "", placeholder = "これ，は,例,です"),
    upload_fileUI(
      id = "stop_words", 
      instruction = c("Prepare stop words file", "Updoad the file"), 
      example_description = "http://svn.sourceforge.jp/svnroot/slothlib/CSharp/Version1/SlothLib/NLP/Filter/StopWord/word/Japanese.txt",
      select_column = FALSE),
  ),

  # # # Synonym # # #
  tabPanel("Synonym",
    tags$h3("Input and/or Upload synonym"),
    textInput("synonym_2", label = "Input synonym combined with '=' and separated with ',' or '，'", value = "", placeholder = "出来る=できる,わかる=分かる"),
    upload_fileUI(
      id = "synonym", 
      instruction = c("Prepare synonym file", "Updoad the file"),
      select_column = FALSE),
  ),

  # # # Cleanup # # #
  tabPanel("Cleanup",
    tags$h3("Cleanup"),
    cleanupUI(id = "cleanup"),
  ),

  # # Bigram # # #
  tabPanel("Bigram",
    bigramUI("bigram")
  ),

)
