#' Decompose an R function
#' 
#' @export
#' @importFrom utils getParseData
#' @param x a function
#' @return result of [utils::getParseData()], a data.frame; but 
#' we wrap it in a thin S3 wrapper to make it easy to see how the
#' function changes as you modify it with [ast_modify()]
#' @examples
#' foo <- function(x) {
#'   x + 1
#' }
#' foo(5)
#' df <- ast_decompose(foo)
#' df
#' data.frame(df)
#' attributes(df)
#' attr(df, "expr")
#' attr(df, "expr")[1,"text"] # the original fxn
ast_decompose <- function(x) {
  name <- deparse(substitute(x))
  pp <- parse(text = deparse(x), keep.source = TRUE)
  d <- utils::getParseData(pp, includeText = TRUE)
  expr <- d[d$token %in% "expr", ]
  dd <- d[!d$token %in% c("expr", "forcond"), ]
  structure(dd, class = c("ast", "data.frame"), name = name, expr = expr)
}
