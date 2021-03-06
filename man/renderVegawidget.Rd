% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vegawidget.R
\name{renderVegawidget}
\alias{renderVegawidget}
\title{Render shiny-output for vegawidget}
\usage{
renderVegawidget(expr, env = parent.frame(), quoted = FALSE)
}
\arguments{
\item{expr}{expression that generates a vegawidget. This can be
a \code{vegawidget} or a \code{vegaspec}.}

\item{env}{The environment in which to evaluate \code{expr}.}

\item{quoted}{Is \code{expr} a quoted expression (with \code{quote()})? This
is useful if you want to save an expression in a variable.}
}
\description{
Use this function in the server part of your Shiny app.
}
