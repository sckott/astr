test_that("ast_decompose", {
  foo <- function(x) {
    x + 1
  }
  expect_is(foo, "function")
  z <- ast_decompose(foo)
  expect_is(z, "ast")
  expect_is(z, "data.frame")
  zdf <- data.frame(z)
  expect_is(zdf, "data.frame")
  expect_named(zdf)
})
