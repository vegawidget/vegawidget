
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/vegawidget/vegawidget.svg?branch=master)](https://travis-ci.org/ijlyttle/vegawidget)
[![CRAN
status](https://www.r-pkg.org/badges/version/vegawidget)](https://cran.r-project.org/package=vegawidget)

# vegawidget

The goal of vegawidget is to handle the rendering into htmlwidgets for
Vega-Lite and Vega specifications.

For now, this document will serve a manifesto for what we might hope for
the package.

## Specifications

The beautiful thing about Vega and Vega-Lite specifications is that they
are just text, formatted as JSON.

The central function here will be `vegawidget()`. Its supporting
function will be `examine()`.

I think each of these functions should be S3 generics for which we
provide methods for:

  - list
  - character
  - `jsonlite` `json` object

For a package such as **altair**, it becomes that packge’s
responsibility to provide generics for its objects.

In the future, challenges will include:

  - using `gistr` to create a block.
  - when knitting to a non-interactive format, e.g. `github_document`
    getting the “right” thing to happen
  - offering **crosstalk** compatibility
  - offering reactive **shiny** behavior, like **ggvis** provides for
    its Vega specifications

## Installation

You can install vegawidget from github with:

``` r
# install.packages("devtools")
devtools::install_github("vegawidget/vegawidget")
```
