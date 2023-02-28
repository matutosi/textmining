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
