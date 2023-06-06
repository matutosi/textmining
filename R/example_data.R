
example_text <- function(){
  #   moranajp::unescape_utf(review)
  moranajp::unescape_utf(review) %>% utils::head(10) # for test
}

example_stop_words <- function(){
  tibble::tibble(stop_words = c("の", "が"))
}

example_synonym <- function(){
  tibble::tibble(from = c("田んぼ", "ケネザサ"), to = c("水田", "ネザサ"))
}
