example_text <- function(){
  #   moranajp::unescape_utf(review)
  moranajp::unescape_utf(review) %>% utils::head() # for test
}

example_stop_words <- function(){
  moranajp::unescape_utf(stop_words)
}

example_synonym <- function(){
  tibble::tibble(
    from =
      c("\\u51fa\\u6765\\u308b",       "\\u308f\\u304b\\u308b",       "\\u307f\\u308b",
        "\\u3088\\u3044",              "\\u3044\\u3044",              "\\u7121\\u3044",
        "\\u6709\\u308b",              "\\u5b50\\u4f9b",              "\\u3082\\u3064",
        "\\u5909\\u3048\\u308b",       "\\u7de0\\u3081\\u5207\\u308a","\\u3006\\u5207",
        "\\u3006\\u5207\\u308a",       "\\u7de0\\u5207\\u308a",       "\\u671f\\u9650"),
    to =
      c("\\u3067\\u304d\\u308b","\\u5206\\u304b\\u308b","\\u898b\\u308b", "\\u826f\\u3044",
        "\\u826f\\u3044",       "\\u306a\\u3044",       "\\u3042\\u308b", "\\u5b50\\u3069\\u3082",
        "\\u6301\\u3064",       "\\u5909\\u308f\\u308b","\\u7de0\\u5207", "\\u7de0\\u5207",
        "\\u7de0\\u5207",       "\\u7de0\\u5207",       "\\u7de0\\u5207")
  ) %>%
  moranajp::unescape_utf()
}
