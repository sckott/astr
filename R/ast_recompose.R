#' Recompose an R function
#' 
#' @export
#' @param x an object of class `ast`
#' @param as_expr (logical) return the function as an expression?
#' default: `FALSE`
#' @return a function as a character string, or an expression if
#' `as_expr=TRUE`
#' @examples
#' foo <- function(x) {
#'   x + 1
#' }
#' foo(5)
#' 
#' # decompose the function
#' df <- ast_decompose(foo)
#' df
#' 
#' # recompose the function
#' fun <- ast_recompose(df)
#' fun
#' 
#' parse(text = fun)
#' eval(parse(text = fun))
#' eval(parse(text = fun))(5)
ast_recompose <- function(x, as_expr = FALSE) {
  assert(x, c("ast", "data.frame"))
  assert(as_expr, "logical")
  stopifnot(all(c("line1", "col1", "col2", "text") %in% names(x)))
  zz <- split(x, x$line1)
  res <- lapply(zz, function(w) {
    each_line <- c()
    for (i in seq_len(NROW(w))) {
      txt <- w$text[i]
      end <- w$col2[i-1]
      start <- w$col1[i]
      if (length(end) == 0) {
        each_line[i] = paste0(wsn(w$col1[i]), txt)
      } else {
        if (start != end) {
          each_line[i] = paste0(wsn(start - end), txt)
        } else {
          each_line[i] = txt
        }
      }
    }
    paste0(each_line, collapse = "")
  })
  fun <- paste0(res, collapse = "\n")
  if (as_expr) fun <- parse(text = fun)
  return(fun)
}

# cat(fun)
# exprs = parse(text = fun)
# eval(exprs)(2)
