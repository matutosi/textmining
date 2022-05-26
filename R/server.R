  # https://matutosi.shinyapps.io/ecanvis/
function(input, output, session){

  # # # Data load # # #
  data_in <- data_loadServer("data_load")

  # # # Bigram # # #
  bigramServer("bigram", data_in())


}
  # devtools::load_all("../ecan/R")
