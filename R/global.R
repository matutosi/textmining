  # https://matutosi.shinyapps.io/textmining2/
  # install.packages("moranajp")
  # devtools::install_github("matutosi/moranajp")
  # devtools::load_all("d:/matu/work/todo/moranajp/")
  # if(!require("devtools"))        install.packages("devtools")
  # if(!require("shiny"))           install.packages("shiny")
  # if(!require("shinycssloaders")) install.packages("shinycssloaders")
  # if(!require("readr"))           install.packages("readr")
  # if(!require("reactable"))       install.packages("reactable")
  # if(!require("colourpicker"))    install.packages("colourpicker")

library(shiny)
library(moranajp)

  # ui.R
  # server.R

  # source("load_data.R")
source("upload_file.R")
source("download_data.R")
source("example_data.R")
source("chamame.R")
source("cleanup.R")
source("bigram.R")
source("utils.R")

  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
  #
  # Japanese font settings
  #
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
  #   https://github.com/ltl-manabi/shinyapps.io_japanese_font
  #   https://raw.githubusercontent.com/ltl-manabi/shinyapps.io_japanese_font/master/use_ipaex_font.sh
  #   https://mana.bi/wiki.cgi?page=shinyapps%2Eio%A4%C7%C7%A4%B0%D5%A4%CE%C6%FC%CB%DC%B8%EC%A5%D5%A5%A9%A5%F3%A5%C8%A4%F2%BB%C8%A4%A6
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
  # # 4 fonts
  # # download.file("https://raw.githubusercontent.com/ltl-manabi/shinyapps.io_japanese_font/master/use_4_font.sh", destfile = "use_4_font.sh")
os <- get_os()
if(os == "linux"){
  system("bash ./use_4_font.sh")
}
font_choices <- 
  switch(os,
    "win"   = c("Meiryo UI", "Yu Gothic", "Yu Mincho"),
    "linux" = c("IPAexGothic", "Source Han Sans", "Noto Sans CJK JP", "SetoFont", "IPAexMincho", "Source Han Serif", "Noto Serif CJK JP"),
    "mac"   = c("HiraKakuPro-W3", "HiraginoSans-W0", "YuMin-Medium", "YuKyo-Medium")
  )
