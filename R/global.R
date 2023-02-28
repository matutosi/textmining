  # https://matutosi.shinyapps.io/ecanvis/
  # install.packages("moranajp")
if(!require("devtools"))        install.packages("devtools")
if(!require("shiny"))           install.packages("shiny")
if(!require("shinycssloaders")) install.packages("shinycssloaders")
if(!require("readr"))           install.packages("readr")
if(!require("reactable"))       install.packages("reactable")
if(!require("colourpicker"))    install.packages("colourpicker")
if(!require("bit"))             install.packages("bit")

library(shiny)
  # library(devtools)
  # library(shinycssloaders)
devtools::load_all("d:/matu/work/todo/moranajp/")
  # library(moranajp)
  # library(reactable)

source("load_data.R")
source("chamame.R")
source("bigram.R")
source("download_data.R")
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

    # # # use only in shiny.io # # #
    # # 4 fonts
    # # download.file("https://raw.githubusercontent.com/ltl-manabi/shinyapps.io_japanese_font/master/use_4_font.sh", destfile = "use_4_font.sh")
if(get_os() == "linux"){
  system("bash ./use_4_font.sh")
}

font_win   <- c("Meiryo UI", "Yu Gothic", "Yu Mincho")
font_linux <- c("IPAexGothic", "Source Han Sans", "Noto Sans CJK JP", "SetoFont", "IPAexMincho", "Source Han Serif", "Noto Serif CJK JP")
font_mac   <- c("HiraKakuPro-W3", "HiraginoSans-W0", "YuMin-Medium", "YuKyo-Medium")
if(get_os() == "win")  { font_choices <- font_win   }
if(get_os() == "linux"){ font_choices <- font_linux }
if(get_os() == "mac")  { font_choices <- font_mac   }
