#' @export
print.ast <- function(x, ...) {
  nm <- crayon::style(attr(x, "name"), "green")
  cat(sprintf("{ fxn: %s }", nm), sep = "\n")
  fun <- ast_recompose(x)
  cat(fun)
}
