#' Add ids.
#' 
#' @param x              A string vector.
#' @param brk            A string to specify the break between ids.
#' @param col            A string to specify the column.
#' @param df             A dataframe.
#' @param end_with_brk   A logical.
#'                       TRUE: brk means the end of groups.
#'                       FALSE: brk means the begining of groups.
#' 
#' @return  id_with_break() returns id vector, add_id_df() returns dataframe.
#' @examples
#' tmp <- c("a", "brk", "b", "brk", "c")
#' brk <- "brk"
#' id_with_break(tmp, brk)
#' add_id_df(tibble::tibble(tmp), col = "tmp", "brk")
#' 
#' @export
id_with_break <- function(x, brk, end_with_brk = TRUE){
  id <- purrr::accumulate(x == brk, sum) + 1
  if(end_with_brk) id <- c(1, id)[-length(id)]
  return(id)
}
add_id_df <- function(df, col, brk, end_with_brk = TRUE){
  x <- df[[col]]
  id <- id_with_break(x, brk, end_with_brk)
  dplyr::bind_cols(df, id = id)
}