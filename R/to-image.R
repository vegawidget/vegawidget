#' Create or write image
#'
#' If [**node**]() is installed, these functions can be used to create
#' or write images as PNG or SVG, using a `vegaspec` or `vegawidget`.
#'
#' These functions can be called using (an object that can be coerced to)
#' a `vegaspec`.
#'
#' For writing a `png`, the `rsvg` package is needed in addition to
#' **node**.
#'
#' The **node** scripts used are adapted from the command line utilies in the
#' vega-cli package.
#'
#'
#' @name image
#' @param spec `vegaspec` object that is or can be coerced to a `vegaspec`,
#'   e.g. a vegawidget object.
#' @param path   `character`, local path to which to write file
#' @param dpi  `numeric`, numeric vector of length 1 or 2 specifying the
#'   resolution of the image in DPI (dots per length) for x and y
#'   (in that order). See \code{\link[png]{writePNG}}
#' @param width,height `numeric`, output width and height in pixels (or NULL for
#'   default) for bitmap or PNG output
#' @param widget `vegawidget`, created using [vegawidget()]
#'
#' @return \describe{
#'   \item{`vw_to_png()`}{`array`, bitmap array}
#'   \item{`vw_to_svg()`}{`character`, SVG string}
#'   \item{`vw_write_png()`}{invisible `vegaspec` or `vegawidget`}
#'   \item{`vw_write_svg()`}{invisible `vegaspec` or `vegawidget`}
#' }
#'
#' @examples
#' \dontrun{
#'   # call any of these functions using either a vegaspec or a vegawidget
#'   vw_to_svg(vegawidget(spec_mtcars))
#'   vw_to_bitmap(spec_mtcars)
#'   vw_write_png(spec_mtcars, "temp.png")
#'   vw_write_svg(spec_mtcars, "temp.svg")
#' }
#' @seealso [vega-view library](https://github.com/vega/vega-view#image-export),
#'

#' @rdname image
#' @export
#'
vw_to_svg <- function(spec, seed = sample(1e8, size = 1), base = "", width = NULL, height = NULL) {

  # Check dependencies
  assert_packages("processx")
  check_node_installed()

  vega_spec <- vw_to_vega(.autosize(as_vegaspec(spec), width = width, height = height))
  str_spec <- vw_as_json(vega_spec, pretty = FALSE)

  # Write the spec to a temporary file
  spec_path <- tempfile(fileext = ".json")
  cat(str_spec, file = spec_path)

  # Get the package location -- used as argument
  pkg_path <- system.file(package = "vegawidget")

  # Get the script location for the node script that does stuff
  script_path <-  system.file("bin/vega_to_svg.js", package = "vegawidget")

  # Use processx to run the script
  res <- processx::run(script_path, args = c(pkg_path, spec_path, seed, base))

  if (res$stderr != "") {
    stop("Error in compiling to svg:\n", res$stderr)
  }
  res$stdout

}


#' @rdname image
#' @export
#'
vw_to_bitmap <- function(spec, width = NULL, height = NULL, ...) {
  assert_packages("rsvg")
  svg_res <- vw_to_svg(spec, width = width, height = height, ...)
  bm <- rsvg::rsvg(charToRaw(svg_res), width = width, height = height)
  bm
}

