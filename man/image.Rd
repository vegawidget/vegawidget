% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/to-image.R, R/write-image.R
\name{image}
\alias{image}
\alias{vw_to_svg}
\alias{vw_to_bitmap}
\alias{vw_write_svg}
\alias{vw_write_png}
\title{Create or write image}
\usage{
vw_to_svg(spec, width = NULL, height = NULL, base_url = NULL, seed = NULL)

vw_to_bitmap(spec, scale = 1, width = NULL, height = NULL, ...)

vw_write_svg(spec, path, width = NULL, height = NULL, ...)

vw_write_png(spec, path, scale = 1, width = NULL, height = NULL, ...)
}
\arguments{
\item{spec}{An object to be coerced to \code{vegaspec}, a Vega/Vega-Lite specification}

\item{width}{\code{integer}, if specified, the total rendered width (in pixels)
of the chart - valid only for single-view charts and layered charts;
the default is to use the width in the chart specification}

\item{height}{\code{integer}, if specified, the total rendered height (in pixels)
of the chart - valid only for single-view charts and layered charts;
the default is to use the height in the chart specification}

\item{base_url}{\code{character}, the base URL for a data file, useful for
specifying a local directory; defaults to an empty string}

\item{seed}{\code{integer}, the random seed for a Vega specification,
defaults to a "random" integer}

\item{scale}{\code{numeric}, useful for specifying larger images supporting the
increased-resolution of retina displays}

\item{...}{additional arguments passed to \code{vw_to_svg()}}

\item{path}{\code{character}, local path to which to write the file}
}
\value{
\describe{
\item{\code{vw_to_svg()}}{\code{character}, SVG string}
\item{\code{vw_to_bitmap()}}{\code{array}, bitmap array}
\item{\code{vw_write_svg()}}{invisible \code{vegaspec} or \code{vegawidget}, called for side-effects}
\item{\code{vw_write_png()}}{invisible \code{vegaspec} or \code{vegawidget}, called for side-effects}
}
}
\description{
If you have \strong{\href{https://CRAN.R-project.org/package=V8}{V8}},
\strong{\href{https://withr.r-lib.org/}{withr}},  and \strong{\href{https://fs.r-lib.org/}{fs}}
installed, you can use these functions can to create
or write images as PNG or SVG, using a \code{vegaspec} or \code{vegawidget}.
To convert to a bitmap, or write a PNG file, you will additionally need
the \strong{\href{https://CRAN.R-project.org/package=rsvg}{rsvg}} and
\strong{\href{https://CRAN.R-project.org/package=png}{png}} packages.
}
\details{
These functions can be called using (an object that can be coerced to)
a \code{vegaspec}.

The scripts used are adapted from the Vega
\href{https://vega.github.io/vega/usage/#cli}{command line utilities}.
}
\examples{
  # call any of these functions using either a vegaspec or a vegawidget
  svg <- vw_to_svg(vegawidget(spec_mtcars))
  bmp <- vw_to_bitmap(spec_mtcars)
  vw_write_png(spec_mtcars, file.path(tempdir(), "temp.png"))
  vw_write_svg(spec_mtcars, file.path(tempdir(), "temp.svg"))

  # To specify the path to a local file, use base_url
  spec_precip <-
    list(
      `$schema` = vega_schema(),
      data = list(url = "seattle-weather.csv"),
      mark = "tick",
      encoding = list(
        x = list(field = "precipitation", type = "quantitative")
      )
    ) \%>\%
    as_vegaspec()

  data_dir <- system.file("example-data/", package = "vegawidget")
  vw_write_png(
    spec_precip,
    file.path(tempdir(), "temp-local.png"),
    base_url = data_dir
  )

}
\seealso{
\href{https://github.com/vega/vega-view#image-export}{vega-view library}
}
