  # https://matutosi.shinyapps.io/ecanvis/
if(!require("devtools"))        install.packages("devtools")
if(!require("shiny"))           install.packages("shiny")
if(!require("shinycssloaders")) install.packages("shinycssloaders")
if(!require("tidyverse"))       install.packages("tidyverse")
  # if(!require("moranajp"))        
devtools::install_github("matutosi/moranajp", force = TRUE)
if(!require("reactable"))       install.packages("reactable")
if(!require("igraph"))          install.packages("igraph")
if(!require("ggraph"))          install.packages("ggraph")
if(!require("colourpicker"))    install.packages("colourpicker")
if(!require("bit"))             install.packages("bit")

library(devtools)
library(shiny)
library(shinycssloaders)
library(tidyverse)
library(moranajp)
library(reactable)
library(igraph)
library(ggraph)

source("utils.R")
source("load_data.R")
source("mecab.R")
source("cleaning.R")
source("bigram.R")
source("download_data.R")

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
