#' Create or write image
#'
#' If you have **[V8](https://CRAN.R-project.org/package=V8)**,
#' **[withr](https://withr.r-lib.org/)**,  and **[fs](https://fs.r-lib.org/)**
#' installed, you can use these functions can to create
#' or write images as PNG or SVG, using a `vegaspec` or `vegawidget`.
#' To convert to a bitmap, or write a PNG file, you will additionally need
#' the **[rsvg](https://CRAN.R-project.org/package=rsvg)** and
#' **[png](https://CRAN.R-project.org/package=png)** packages.
#'
#' These functions can be called using (an object that can be coerced to)
#' a `vegaspec`.
#'
#' The scripts used are adapted from the Vega
#' [command line utilities](https://vega.github.io/vega/usage/#cli).
#'
#' @name image
#' @inheritParams vw_autosize
#' @param path   `character`, local path to which to write the file
#' @param scale  `numeric`, useful for specifying larger images supporting the
#'   increased-resolution of retina displays
#' @param base_url `character`, the base URL for a data file, useful for
#'   specifying a local directory; defaults to an empty string
#' @param seed `integer`, the random seed for a Vega specification,
#'   defaults to a "random" integer
#' @param ... additional arguments passed to `vw_to_svg()`
#'
#' @return \describe{
#'   \item{`vw_to_svg()`}{`character`, SVG string}
#'   \item{`vw_to_bitmap()`}{`array`, bitmap array}
#'   \item{`vw_write_svg()`}{invisible `vegaspec` or `vegawidget`, called for side-effects}
#'   \item{`vw_write_png()`}{invisible `vegaspec` or `vegawidget`, called for side-effects}
#' }
#'
#' @examples
#'   # call any of these functions using either a vegaspec or a vegawidget
#'   svg <- vw_to_svg(vegawidget(spec_mtcars))
#'   bmp <- vw_to_bitmap(spec_mtcars)
#'   vw_write_png(spec_mtcars, file.path(tempdir(), "temp.png"))
#'   vw_write_svg(spec_mtcars, file.path(tempdir(), "temp.svg"))
#'
#'   # To specify the path to a local file, use base_url
#'   spec_precip <-
#'     list(
#'       `$schema` = vega_schema(),
#'       data = list(url = "seattle-weather.csv"),
#'       mark = "tick",
#'       encoding = list(
#'         x = list(field = "precipitation", type = "quantitative")
#'       )
#'     ) %>%
#'     as_vegaspec()
#'
#'   data_dir <- system.file("example-data/", package = "vegawidget")
#'   vw_write_png(
#'     spec_precip,
#'     file.path(tempdir(), "temp-local.png"),
#'     base_url = data_dir
#'   )
#'
#' @seealso [vega-view library](https://github.com/vega/vega-view#image-export)
#'
#' @rdname image
#' @export
#'
vw_to_svg <- function(spec, width = NULL, height = NULL, base_url = NULL,
                      seed = NULL) {

  assert_packages(c("V8", "fs", "withr"))

  # set defaults
  base_url <-
    base_url %||% getOption("vega.embed")[["loader"]][["baseURL"]] %||% ""
  seed <- seed %||% sample(1e8, size = 1)

  # convert to vega spec as a string
  spec <- vw_autosize(spec, width = width, height = height)
  vega_spec <- vw_to_vega(spec)
  str_spec <- vw_as_json(vega_spec, pretty = FALSE)

  # determine versions of vega, vega-lite
  version_all <- vega_version_all()
  spec_version <- vw_spec_version(spec)
  widget <-
    get_widget_string(
      spec_version[["library"]],
      spec_version[["version"]],
      version_all
    )

  version_widget <- version_all[version_all[["widget"]] == widget, ]
  version_vega <- version_widget[["vega"]]
  version_vega_lite <- version_widget[["vega_lite"]]

  # fire up V8
  ct <- V8::v8()
  ct$source(widgetlib_file("vega", glue::glue("vega@{version_vega}.min.js")))
  ct$source(bin_file("vega_to_svg_v8.js"))

  # send arguments
  ct$assign("spec", V8::JS(str_spec)) # send as JSON text to avoid jsonlite defaults
  ct$assign("seed", seed)
  ct$assign("baseURL", base_url)

  # evaluate render-function
  lines_returned <- ct$eval("vwRender(spec, seed, baseURL)", await = TRUE)

  paste(lines_returned, collapse = "\n")
}

#' @rdname image
#' @export
#'
vw_to_bitmap <- function(spec, scale = 1, width = NULL, height = NULL, ...) {

  assert_packages("rsvg")

  # create the svg
  svg_res <- vw_to_svg(spec, width = width, height = height, ...)

  # determine the dimensions of the image using `scale`
  dim_svg <- svg_dim(svg_res)
  width_img <- dim_svg$width * scale
  height_img <- dim_svg$height * scale

  bm <- rsvg::rsvg(charToRaw(svg_res), width = width_img, height = height_img)

  bm
}

# internal function to scrape the text of an SVG string
#  to return a list of `width` and `height`
#
svg_dim <- function(svg) {

  # grab the contents of the viewBox string
  s <- gsub(".*viewBox=\"([^\"]+)\".*", "\\1", svg)

  # split string using spaced
  s <- strsplit(s, " ")
  num <- as.numeric(s[[1]])

  # extract the width and height into a list
  dim <- list(width = num[[3]], height = num[[4]])

  dim
}
