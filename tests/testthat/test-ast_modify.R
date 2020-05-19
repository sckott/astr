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
  expect_true(any(z$mutated))
  mut <- na.omit(z$mutated_from_to)
  expect_is(mut, "character")
  expect_equal(mut[1], "+,-")
})

test_that("ast_modify - many", {
  bar <- function(x) {
    z <- x + 1
    w <- z / 10
    w + 5
  }

  b <- ast_decompose(bar)

  z1 <- ast_modify(b, "+", "-", if_many = "random")
  df1 <- data.frame(z1)

  z2 <- ast_modify(b, "+", "-", if_many = "first")
  df2 <- data.frame(z2)
  
  z3 <- ast_modify(b, "+", "-", if_many = "all")
  df3 <- data.frame(z3)

  expect_true(length(df1$mutated[df1$mutated]) == 1)
  expect_true(length(df2$mutated[df2$mutated]) == 1)
  expect_true(length(df3$mutated[df3$mutated]) > 1)
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
  # no_match not of specified class
  expect_error(ast_modify(structure('x', class="ast"), "x", "x", no_match = 5))
  # no_match not in allowed set
  expect_error(ast_modify(structure('x', class="ast"), "x", "x", no_match = print))

  # no match found
  expect_error(ast_modify(b, "-", "-"))
})
