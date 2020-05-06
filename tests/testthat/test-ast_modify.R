test_that("ast_modify", {
  foo <- function(x) {
    x + 1
  }

  b <- ast_decompose(foo)
  z <- ast_modify(b, "+", "-")
  expect_is(z, "ast")
  expect_is(data.frame(z), "data.frame")
  expect_true(any(b$text == "+"))
  expect_false(any(z$text == "+"))
})

test_that("ast_modify fails well", {
  # x missing
  expect_error(ast_modify())
  # x wrong class
  expect_error(ast_modify(5))
  # from missing
  expect_error(ast_modify(structure('x', class="ast")))
  # from wrong class
  expect_error(ast_modify(structure('x', class="ast"), 5))
  # to wrong class
  expect_error(ast_modify(structure('x', class="ast"), "x", 5))
  # if_many wrong class
  expect_error(ast_modify(structure('x', class="ast"), "x", "x", 5))
  # if_many not in allowed set
  expect_error(ast_modify(structure('x', class="ast"), "x", "x", "x"))

  # no match found
  expect_error(ast_modify(b, "-", "-"))
})
