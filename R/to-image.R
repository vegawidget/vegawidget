#' Create or write image
#'
#' If the [**webdriver**](https://cran.r-project.org/package=webdriver) package
#' and PhantomJS are installed, these functions can be used to create
#' or write images as PNG or SVG, using a `vegaspec` or `vegawidget`.
#'
#' These functions can be called using (an object that can be coerced to)
#' a `vegaspec` or a `vegawidget`. In addition to the
#' [**webdriver**](https://cran.r-project.org/package=webdriver) package,
#' you may also need to install PhantomJS; you can use
#' [webdriver::install_phantomjs()].
#'
#' Images are created using the
#' [vega-view](https://github.com/vega/vega-view#image-export) image-export
#' functions. These functions accept a scale factor, represented here as the
#' `scale` argument. By specifying `scale = 2` for the PNG functions, a
#' retina-ready image will be generated.
#'
#' The `vw_to_png()` function returns a data-URI string for the PNG image. If
#' you want this PNG image as `raw` binary data, use `vw_to_png()` followed by
#' [vw_png_bin()].
#'
#' @name image
#' @inheritParams vegawidget
#' @param path   `character`, local path to which to write file
#' @param scale  `numeric`, scale-factor for the image:
#'   ratio of the width (pixels) of the image to the
#'   width (pixels) of the rendered chart
#' @param widget `vegawidget`, created using [vegawidget()]
#'
#' @return \describe{
#'   \item{`vw_to_png()`}{`character`, data-URI string for PNG}
#'   \item{`vw_to_svg()`}{`character`, SVG string}
#'   \item{`vw_write_png()`}{invisible `vegaspec` or `vegawidget`}
#'   \item{`vw_write_svg()`}{invisible `vegaspec` or `vegawidget`}
#' }
#'
#' @examples
#' \dontrun{
#'   # call any of these functions using either a vegaspec or a vegawidget
#'   vw_to_svg(vegawidget(spec_mtcars))
#'   write_png(spec_mtcars, "temp.png")
#'   spec_mtcars %>% vw_to_png() %>% vw_png_bin()
#' }
#' @seealso [webdriver::install_phantomjs()],
#' [vega-view library](https://github.com/vega/vega-view#image-export),
#' [vw_png_bin()]
#'

#' @rdname image
#' @export
#'
vw_to_svg <- function(spec, ...) {
  .vw_to_svg(as_vegaspec(spec), ...)
}

.vw_to_svg <- function(spec, ...) {
  UseMethod(".vw_to_svg")
}

#' @rdname image
#' @export
#'
.vw_to_svg.default <- function(spec, ...) {
  stop(".autosize(): no method for class ", class(spec), call. = FALSE)
}

.vw_to_svg.vegaspec_vega_lite <- function(spec, ...) {

  vega_spec <- vw_to_vega(spec)
  .vw_to_svg.vegaspec_vega(vega_spec, ...)
}

.vw_to_svg.vegaspec_vega <- function(spec, seed = 2018, base = "") {

  # Check dependencies
  assert_packages("processx")
  check_node_installed()

  str_spec <- vw_as_json(spec, pretty = FALSE)

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
vw_to_png <- function(spec, file, width = NULL, height = NULL, ...) {
 svg_res <- vw_to_svg(spec, ...)
 rsvg::rsvg_png(charToRaw(svg_res), file = file, width = width, height = height)
}

