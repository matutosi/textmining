clean_mecab_local_2 <- function(df){
  add_stop_words <- 
    c("\\u3042\\u308b", "\\u3059\\u308b", "\\u3066\\u308b", 
      "\\u3044\\u308b","\\u306e", "\\u306a\\u308b", "\\u304a\\u308b", 
      "\\u3093", "\\u308c\\u308b", "*") %>% 
    stringi::stri_unescape_unicode()

  data(synonym)
  synonym_df <- 
    synonym %>%
    dplyr::mutate_all(stringi::stri_unescape_unicode)

  df %>%
    moranajp::clean_mecab_local(add_stop_words = add_stop_words,
                                synonym_df = synonym_df)
}

clean_chamame_2 <- function(df){
  add_stop_words <- 
    c("\\u3042\\u308b", "\\u3059\\u308b", "\\u3066\\u308b", 
      "\\u3044\\u308b","\\u306e", "\\u306a\\u308b", "\\u304a\\u308b", 
      "\\u3093", "\\u308c\\u308b", "*") %>% 
    stringi::stri_unescape_unicode()

  data(synonym)
  synonym_df <- 
    synonym %>%
    dplyr::mutate_all(stringi::stri_unescape_unicode)

  df %>%
    moranajp::clean_chamame(add_stop_words = add_stop_words,
                            synonym_df = synonym_df)
}
