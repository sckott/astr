#' Modify an R function
#' 
#' @export
#' @param x an object of class `ast`
#' @param from (character) character string to replace. note that we look
#' for an exact match
#' @param to (character) character string to put in place of `from`
#' @param if_many (character) if multiple matches to the `from` parameter
#' input, should we randomly select one to replace, replace the first instance,
#' or replace all? one of: first, all, random
#' @return same as the input, an object of class `ast`, but modified
#' @details we check that the `from` input has a match in the function
#' data, if not, we fail out
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
#' # modify an aspect of the function
#' out <- ast_modify(x = df, from = "+", to = "-")
#' out
#' class(out)
#' attributes(out)
#' data.frame(out)
#' 
#' # more examples
#' bar <- function(x) x / 6
#' (z <- ast_decompose(bar))
#' ast_modify(z, from = "/", to = "*")
#' 
#' # to get the new function, pass through ast_recompose
#' b <- ast_modify(z, from = "/", to = "*")
#' newbar <- ast_recompose(b, TRUE)
#' bar(7)
#' eval(newbar)(7)
#' 
#' # multiple from matches
#' foo <- function(x) {
#'   w <- x + 1
#'   w + 5
#' }
#' foo(1)
#' x <- ast_decompose(foo)
#' (w <- ast_modify(x, "+", "-"))
#' eval(ast_recompose(w, TRUE))(1)
#' 
#' # if_many options
#' ast_modify(x, "+", "-", if_many = "random")
#' ast_modify(x, "+", "-", if_many = "random")
#' ast_modify(x, "+", "-", if_many = "random")
#' ast_modify(x, "+", "-", if_many = "first")
#' ast_modify(x, "+", "-", if_many = "all")
ast_modify <- function(x, from, to, if_many = "random") {
  assert(x, "ast")
  assert(from, "character")
  assert(to, "character")
  assert(if_many, "character")
  stopifnot("if_many must be one of random,first,all" =
    if_many %in% c("random", "first", "all"))
  mtch <- grep(from, x$text, fixed = TRUE)
  if (length(mtch) == 0) stop("no match found, reconsider 'from'", call.=FALSE)
  if (length(mtch) > 1) {
    mtch <- switch(if_many, random = sample(mtch, 1), first = mtch[1],
      all = mtch)
  }
  x[mtch, "text"] <- to
  x$mutated <- FALSE
  x$mutated[mtch] <- TRUE
  x$mutated_from_to <- NA_character_
  x$mutated_from_to[mtch] <- paste(from, to, sep = ",")
  return(x)
}
