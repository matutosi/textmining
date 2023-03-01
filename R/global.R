library(shiny)
library(moranajp)
library(shinycssloaders)
library(readr)
library(reactable)
library(colourpicker)

source("load_data.R")
source("chamame.R")
source("bigram.R")
source("download_data.R")
source("utils.R")

os <- get_os()
font_choices <- 
  switch(os,
    "win"   = c("Meiryo UI", "Yu Gothic", "Yu Mincho"),
    "linux" = c("IPAexGothic", "Noto Sans CJK JP", "IPAexMincho", "Noto Serif CJK JP", "SetoFont"),
    "mac"   = c("HiraKakuPro-W3", "HiraginoSans-W0", "YuMin-Medium", "YuKyo-Medium")
  )

if(0){ # # # # # TEST CODE # # # # # 



}
