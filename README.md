
<!-- README.md is generated from README.Rmd. Please edit that file -->

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
  - JSON

For a package such as **altair**, it becomes that packge’s
responsibility to provide generics for its objects.

In the future, challenges will include:

  - offering **crosstalk** compatibility
  - offering reactive **shiny** behavior, like **ggvis** provides for
    its Vega specifications

## Installation

You can install vegawidget from github with:

``` r
# install.packages("devtools")
devtools::install_github("vegawidget/vegawidget")
```
