## convert strings into shiny.tag
str2li <- function(str, ol = TRUE){
  li <- ifelse(ol, "ol", "ul")
  li <- paste0('tags$', li, '(')
  for(s in str){
    li <- paste0(li, 'tags$li("', s, '"),')
  }
  li <- paste0(li, ')')
  eval(str2expression(li))
}

## change font with os in bigram
get_os <- function(){
  switch(Sys.info()["sysname"],
    "Windows" = "win",
     "Linux"  = "linux",
                "mac"
  )
}

## for debug
printx <- function(x){
  name <- substitute(x)
  print(paste0(name, ": "))
  print(x)
}

