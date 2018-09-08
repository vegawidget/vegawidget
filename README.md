
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/vegawidget/vegawidget.svg?branch=master)](https://travis-ci.org/vegawidget/vegawidget)
[![CRAN
status](https://www.r-pkg.org/badges/version/vegawidget)](https://cran.r-project.org/package=vegawidget)

# vegawidget

The goal of vegawidget is to render Vega-Lite and Vega specifications
into htmlwidgets. Its ambition is to be a low-level interface to the
Vega(-Lite) API, such that other packages can build upon it to offer
higher-level functions to compose Vega(-Lite) specifications.

## Installation

You can install vegawidget from github with:

``` r
# install.packages("devtools")
devtools::install_github("vegawidget/vegawidget")
```

An [interactive
tutorial](https://ijlyttle.shinyapps.io/vegawidget-overview) is
available at shinyapps.io.

## Introduction

Vega(-Lite) specifications are just text, formatted as JSON. However, in
R, we can use lists to build such specifications:

``` r
library("vegawidget")

spec_mtcars <-
  list(
    `$schema` = vega_schema(), # specifies Vega-Lite
    description = "An mtcars example.",
    data = list(values = mtcars),
    mark = "point",
    encoding = list(
      x = list(field = "wt", type = "quantitative"),
      y = list(field = "mpg", type = "quantitative"),
      color = list(field = "cyl", type = "nominal")
    )
  ) %>% 
  as_vegaspec()
```

The `as_vegaspec()` function is used to turn the list into a *vegaspec*;
a good many of the functions in this package are built to support, and
render, vegaspecs:

``` r
spec_mtcars
```

![](man/figures/README-vegawidget-1.png)<!-- -->

If you are reading this document on the GitHub code site, it is further
rendered into a PNG. In the background, the vegaspec print-method
converts the vegaspec to JSON, using `vw_as_json()`, then renders it as
an htmlwidget using `vegawidget()`.

If you wish to examine a vegaspec, you may use the `vw_examine()`
function, which is a thin wrapper around the `jsonedit()` function from
the **listviewer** package.

``` r
vw_examine(spec_mtcars)
```

![](man/figures/README-unnamed-chunk-2-1.png)<!-- -->

If you wish to deploy a vegaspec to be rendered on
[bl.ocks.org](https://bl.ocks.org/), you can do that, provided you have
a GitHub account.

``` r
vw_create_block(spec_mtcars)
```

Similarly, if a block has a `.json` file with a JSON specification, you
can retrieve and put into a
vegaspec:

``` r
spec_new <- vw_retrieve_block("ijlyttle/06a512525fbe7a96e1a2028e1871b61c")
```

## Integration with other packages

This package provides functions to render Vega(-Lite) specifications;
although it provides some helpers, it dos not provide higher-level
functions to build specifications. Rather, this is left to other
packages. Even though you can use its functions directly, you are
invited to import and re-export them for use in *your* package.

Accordingly, this package offers a templating function,
`use_vegawidget()`, to help you integrate vegawidget functions into your
package. This function is used to [import and re-export vegawidget
functions](https://github.com/vegawidget/altair/blob/master/R/utils-vegawidget.R)
for the [altair](https://vegawidget.github.io/altair) package.
