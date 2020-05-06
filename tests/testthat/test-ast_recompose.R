test_that("ast_recompose", {
  foo <- function(x) {
    x + 1
  }

  # w/o modifications 
  b <- ast_decompose(foo)
  z <- ast_recompose(b, as_expr = TRUE)
  expect_identical(foo, eval(z))

  # w/ modifications 
  b <- ast_decompose(foo)
  df <- data.frame(b)
  df[df$text == "+", "text"] <- "-"
  z <- ast_recompose(df, as_expr = TRUE)
  expect_gt(foo(1), eval(z)(1))
})
