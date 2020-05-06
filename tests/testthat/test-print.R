test_that("ast_modify", {
  foo <- function(x) {
    x + 1
  }

  b <- ast_decompose(foo)
  expect_output(print(b), "fxn:")
  expect_output(print(b), "function \\(")
  expect_output(print(b), "x \\+ 1")
})
