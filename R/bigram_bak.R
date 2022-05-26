library(tidyverse)

## load file
path <- "D:/matu/work/ToDo/textmining/tools/webchamame_20220525121559.csv"
mecab_res <- 
  readr::read_csv(path, col_types = "c") %>%
  magrittr::set_colnames(LETTERS[seq_len(ncol(.))]) %>%
  dplyr::select(term = L, pos = F) %>%
  tidyr::separate(pos, into = c("pos0", "pos1"), 
    sep="-", extra = "drop", fill = "right") %>%
  dplyr::mutate(pos0 = tidyr::replace_na(pos0, "-")) %>%
  dplyr::mutate(pos1 = tidyr::replace_na(pos1, "-")) %>%
  add_id_df("pos1", "句点")

## pre-cleaning
## filter by pos (parts of speech) settings
  # memo for deciding filtering pos0 and pos1
  # 
  #   mecab_res %>%
  #     separate(品詞, into = c("t1", "t2"), sep="-") %>%
  #     filter(t1 %in% c("名詞", "動詞", "形容詞", "副詞")) %>%
  #     filter(t2 %in% c("普通名詞", "非自立可能", "一般")) %>%
  #     group_by(t1, t2) %>%
  #     tally() %>%
  #     arrange(desc(n)) %>%
  #     print(n=nrow(.))
  #   pos0
  #    1 名詞      4184
  #    3 動詞      2114
  #    7 形容詞     213
  #    9 副詞       101
  #   pos1
  #   1 普通名詞    3970
  #   2 非自立可能  1243
  #   3 一般        1084
  # 
filter_pos0 <- c("名詞", "動詞", "形容詞", "副詞")
filter_pos1 <- c("普通名詞", "非自立可能", "一般")

## stop_words settings
  #   http://svn.sourceforge.jp/svnroot/slothlib/CSharp/Version1/SlothLib/NLP/Filter/StopWord/word/Japanese.txt
path <- "D:/matu/workOLD/lecture/enq/all/dic/stop_words.txt"
add_stop_words <- c("ある", "する", "てる", "いる", "の", "なる", "おる", "ん", "れる")
stop_words <- 
  readr::read_tsv(path, col_names = FALSE, col_types = "c") %>%
  magrittr::set_colnames("term") %>%
  dplyr::add_row(term = add_stop_words)

## words for replacement (synonym) settings
path <- "D:/matu/work/ToDo/textmining/tools/replace_words.txt"
rep_words <- readr::read_tsv(path, col_types = "c")
replace_words        <- rep_words$to
names(replace_words) <- rep_words$from

## EXECUTE pre-cleaning
mecab_res <- 
  mecab_res %>%
  dplyr::filter(pos0 %in% filter_pos0) %>% # filter by pos (parts of speech)
  dplyr::filter(pos1 %in% filter_pos1) %>%
  dplyr::anti_join(stop_words) %>%
  dplyr::mutate(term = stringr::str_replace_all(term, replace_words)) %>%  # synonym (equivalent term)
    # AGAINST irregular (garble) characters when string length is 1 (it's mysterious)
  dplyr::mutate(term = dplyr::case_when(stringr::str_length(term) == 1 ~ stringr::str_c("　", term), TRUE ~ term))

## bigram
library(igraph)
library(ggraph)

bigram <- 
  mecab_res %>%
  dplyr::group_by(id) %>%
  dplyr::transmute(id, word_1 = term, word_2 = dplyr::lag(term), bigram=stringr::str_c(word_1, " - ", word_2)) %>%
  dplyr::ungroup() %>%
  na.omit()

set.seed(12)
threshold <- 100
  # bigram network
bigram_net <-
  bigram %>%
  dplyr::group_by(word_2, word_1) %>%
  dplyr::summarise(freq = dplyr::n()) %>%
  dplyr::ungroup() %>%                     # if keep group, slice do not work
  dplyr::arrange(dplyr::desc(freq)) %T>%
  { freq_thresh <<- dplyr::slice(., threshold)$freq } %>%  # can change "threshold"
  dplyr::filter(freq > freq_thresh) %>%
  graph_from_data_frame()


  # word frequencty
freq <- 
  mecab_res %>%
  dplyr::group_by(term) %>%
  dplyr::tally() %>%
  dplyr::left_join(tibble::tibble(term = V(bigram_net)$name), .) %>%
  .$n %>%
  log() %>%
  round(0) * 2

## plot

  # plot
bigram_network_raw <- 
  bigram_net %>%
    ggraph(layout = "fr") +        # the most understandable
    geom_edge_link(color = "pink", arrow = arrow(length = unit(4, 'mm')), start_cap = circle(4, 'mm'), end_cap = circle(4, 'mm')) +
    geom_node_point(color = "skyblue", size = freq) +
    geom_node_text(aes(label = name), vjust = 1, hjust = 1, size = 5) +
    ggplot2::theme_bw() + 
    theme(axis.title.x = element_blank(), axis.title.y = element_blank())

bigram_network <- 
  bigram_network_raw + 
    scale_x_continuous(breaks = NULL) + 
    scale_y_continuous(breaks = NULL)

bigram_network_detail <- 
  bigram_network_raw + 
    scale_x_continuous(breaks = 1:5, limits = c(-1, 5)) + 
    scale_y_continuous(breaks = 1:5, limits = c( 0, 6))

  # save
ggsave(
  stringr::str_c("2022_tm_", lecture, "_", stringr::str_pad(no, 2, "left", "0"), ".png"), 
  plot = bigram_network, 
  width=14, height=7)

