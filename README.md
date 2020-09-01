astr
====



[![Build Status](https://travis-ci.com/sckott/astr.svg?branch=mastr)](https://travis-ci.com/sckott/astr)
[![codecov.io](https://codecov.io/github/sckott/astr/coverage.svg?branch=mastr)](https://codecov.io/github/sckott/astr?branch=mastr)

Decompose and Recompose Functions

## Install


```r
remotes::install_github("sckott/astr")
```


```r
library("astr")
```

## decompose

a simple function


```r
foo <- function(x) {
  x + 1
}
foo(5)
#> [1] 6
```

decompose the function


```r
df <- ast_decompose(foo)
df
#> { fxn: foo }
#> function (x)
#> {
#>     x + 1
#> }
class(df)
#> [1] "ast"        "data.frame"
```

## modify

modify an aspect of the function


```r
out <- ast_modify(df, from = "+", to = "-")
out
#> { fxn: foo }
#> function (x)
#> {
#>     x - 1
#> }
```

## recompose


```r
ast_recompose(out)
#> [1] "function (x)\n{\n    x - 1\n}"
ex <- ast_recompose(out, as_expr = TRUE)
eval(ex)(5)
#> [1] 4
```

## Meta

* Please [report any issues or bugs](https://github.com/sckott/astr/issues).
* License: MIT
* Get citation information for `astr` in R doing `citation(package = 'astr')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[coc]: https://github.com/sckott/astr/blob/mastr/CODE_OF_CONDUCT.md
