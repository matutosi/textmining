  # https://matutosi.shinyapps.io/ecanvis/
if(!require("devtools"))        install.packages("devtools")
if(!require("shiny"))           install.packages("shiny")
if(!require("shinycssloaders")) install.packages("shinycssloaders")
if(!require("tibble"))          install.packages("tibble")
if(!require("dplyr"))           install.packages("dplyr")
if(!require("readr"))           install.packages("readr")
if(!require("stringi"))         install.packages("stringi")
if(!require("purrr"))           install.packages("purrr")
if(!require("reactable"))       install.packages("reactable")
if(!require("igraph"))          install.packages("igraph")
if(!require("ggraph"))          install.packages("ggraph")
if(!require("colourpicker"))    install.packages("colourpicker")
if(!require("bit"))             install.packages("bit")

library(devtools)
library(shiny)
library(shinycssloaders)
devtools::load_all("d:/matu/work/todo/moranajp/")
  # library(moranajp)
library(reactable)
  # library(igraph)
  # library(ggraph)

source("load_data.R")
source("chamame.R")
  # source("cleaning.R")
  # source("bigram.R")
  # source("download_data.R")

  # windowsFonts(
  #   `Yu Mincho` = windowsFont("Yu Mincho"),
  #   `Yu Gothic` = windowsFont("Yu Gothic"),
  #   `Meiryo UI` = windowsFont("Meiryo UI")
  # )

  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
  #
  # Japanese font settings
  #
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
  #   https://github.com/ltl-manabi/shinyapps.io_japanese_font
  #   https://raw.githubusercontent.com/ltl-manabi/shinyapps.io_japanese_font/master/use_ipaex_font.sh
  #   https://mana.bi/wiki.cgi?page=shinyapps%2Eio%A4%C7%C7%A4%B0%D5%A4%CE%C6%FC%CB%DC%B8%EC%A5%D5%A5%A9%A5%F3%A5%C8%A4%F2%BB%C8%A4%A6
  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #

  # use only in shiny.io
  # 4 fonts
  # download.file("https://raw.githubusercontent.com/ltl-manabi/shinyapps.io_japanese_font/master/use_4_font.sh",
  #   destfile = "use_4_font.sh")
  # system("bash ./use_4_font.sh")
