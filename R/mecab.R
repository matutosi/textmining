## UI module
mecabUI <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(



      ),

      mainPanel(

       reactableOutput(ns("table")),

      ),

    )
  )
}

## Server module
mecabServer <- function(id, data_in){
  moduleServer(id, function(input, output, session){

    # 
    res_moranajp <- reactive({

  #       bin_dir  <- "d:/pf/mecab/bin/"
  #       text_col <- "text"
  #       iconv    <- ""
  # 
  #       data_in() %>%
  #         moranajp::moranajp_all(bin_dir = bin_dir, text_col = text_col, iconv = iconv)

    })

    # Return


  })
}
