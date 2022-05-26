  # https://matutosi.shinyapps.io/ecanvis/
if(!require("devtools"))        install.packages("devtools")
if(!require("shiny"))           install.packages("shiny")
if(!require("shinycssloaders")) install.packages("shinycssloaders")
if(!require("tidyverse"))       install.packages("tidyverse")
if(!require("moranajp"))        install.packages("moranajp")
if(!require("reactable"))       install.packages("reactable")
if(!require("igraph"))          install.packages("igraph")
if(!require("ggraph"))          install.packages("ggraph")

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
source("bigram.R")
