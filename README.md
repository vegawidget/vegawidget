
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.org/vegawidget/vegawidget.svg?branch=master)](https://travis-ci.org/vegawidget/vegawidget)
[![CRAN
status](https://www.r-pkg.org/badges/version/vegawidget)](https://cran.r-project.org/package=vegawidget)

# vegawidget

The goal of vegawidget is to render Vega-Lite and Vega specifications as
htmlwidgets, and to provide you a means to communicate with a Vega chart
using JavaScript or Shiny. Its ambition is to be a *low-level* interface
to the Vega(-Lite) API, such that other packages can build upon it to
offer higher-level functions to compose Vega(-Lite) specifications.

This is the key difference with the
[**vegalite**](https://github.com/hrbrmstr/vegalite) package: it
provides a set of higher-level functions to compose specifications,
whereas **vegawidget** concerns itself mainly with the rendering of the
htmlwidget.

To be clear, although Vega-Lite offers a grammar-of-graphics, this
package does not offer a user-friendly framework to compose graphics,
like those provided by **[ggplot2](https://ggplot2.tidyverse.org)** or
**[ggvis](https://ggvis.rstudio.com)**. However, this package may be
useful to:

  - build re-usable Vega and Vega-Lite specifications for deployment
    elsewhere, if you can tolerate the frustration of building
    specifications using lists.
  - develop higher-level, user-friendly packages to build specific types
    of plots, or even to build a general ggplot2-like framework, using
    this package as a foundation (or inspiration).

## Installation

You can install vegawidget from CRAN with:

``` r
install.packages("vegawidget")
```

The development version of vegawidget is available from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("vegawidget/vegawidget")
```

**Note:** There are documentation websites for both the [CRAN
version](https://vegawidget.github.io/vegawidget) and the [development
version](https://vegawidget.github.io/vegawidget/dev) of this package.

This package supports these versions of Vega libraries:

``` r
library("vegawidget")
vega_version()
#> $vega_lite
#> [1] "3.2.1"
#> 
#> $vega
#> [1] "5.3.3"
#> 
#> $vega_embed
#> [1] "4.0.0"
```

The *first* CRAN version of vegawidget supports Vega-Lite 2.6.0, the
*last* release of Vega-Lite that will run using JavaScript version ES5.
The current version major-version of Vega-Lite, 3, uses JavaScript ES6.

In practical terms, this means that the initial CRAN-version (0.1.0) of
vegawidget will be the *only* CRAN version that will display properly
using version 1.1.x of the RStudio IDE.

This development version of vegawidget uses Vega-Lite 3, as will the
*next* CRAN release of vegawidget.

## Introduction

Vega(-Lite) specifications are just text, formatted as JSON. However, in
R, we can use lists to build specifications:

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
many of this package’s functions are built to support, and render,
vegaspecs:

``` r
spec_mtcars
```

![](man/figures/README-vegawidget-1.svg)<!-- -->

The rendering of the chart above depends on where you are reading it:

  - On this package’s [pkgdown
    site](https://vegawidget.github.io/vegawidget), it is rendered as
    part of an HTML environment, showing its full capabilities.

  - At its [GitHub code site](https://github.com/vegawidget/vegawidget),
    the chart is further rendered to a static SVG file, then
    incorporated into the Markdown rendering.

For more, please see our [Getting
Started](https://vegawidget.github.io/vegawidget/articles/vegawidget.html)
article. For other introductory material, please see:

  - [Vega-Lite website](https://vega.github.io/vega-lite) has a
    comprehensive introduction
  - An [interactive learnr
    tutorial](https://ijlyttle.shinyapps.io/vegawidget-overview) at
    shinyapps.io

Other articles for this package:

  - [Specify using
    vegaspec](https://vegawidget.github.io/vegawidget/articles/vegaspec.html):
    how to construct and render a vegaspec.
  - [Render using
    vegawidget](https://vegawidget.github.io/vegawidget/articles/render-vegawidget.html):
    advanced rendering options.
  - [Extend using
    Shiny](https://vegawidget.github.io/vegawidget/articles/shiny.html):
    how to interact with Vega charts using Shiny.
  - [Extend using
    JavaScript](https://vegawidget.github.io/vegawidget/articles/javascript.html):
    how to interact with Vega charts using JavaScript.
  - [Create
    Images](https://vegawidget.github.io/vegawidget/articles/image.html):
    how to create and save PNG or SVG images.
  - [Work with Dates and
    Times](https://vegawidget.github.io/vegawidget/articles/dates-times.html):
    dates and times in Vega(-Lite) work a little differently from R.
  - [Import into Other
    Packages](https://vegawidget.github.io/vegawidget/articles/import.html):
    how to import vegawidget functions into your package, then re-export
    them.

## Acknowledgements

  - [Alicia Schep](https://github.com/AliciaSchep) has been instrumental
    in guiding the evolution of the API, and for introducing new
    features, particularly the JavaScript and Shiny functions.
  - [Haley Jeppson](https://github.com/haleyjeppson) and [Stuart
    Lee](https://github.com/sa-lee) have provided valuable feedback and
    contributions throughout the package’s development.
  - [Bob Rudis](https://github.com/hrbrmstr) and the
    [vegalite](https://github.com/hrbrmstr/vegalite) package provided a
    lot of the inspiration for this work, providing a high-level
    interface to Vega-Lite.
  - The [Altair](https://altair-viz.github.io) developers, for further
    popularizing the notion of using a programming language (Python) to
    create and render Vega-Lite specifications.  
  - The [Vega-Lite](https://vega.github.io/vega-lite/) developers, for
    providing a foundation upon which the rest of this is built.

## Contributing

Contributions are welcome, please see this [guide](CONTRIBUTING.md).
Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
