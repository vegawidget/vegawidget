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
#' [vega-view](https://github.com/vega/vega/tree/master/packages/vega-view#image-export) image-export
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
#' [vega-view library](https://github.com/vega/vega/tree/master/packages/vega-view#image-export),
#' [vw_png_bin()]
#'

#' @rdname image
#' @export
#'
vw_to_svg <- function(...) {
  UseMethod("vw_to_svg")
}

#' @rdname image
#' @export
#'
vw_to_svg.default <-
  function(spec, scale = 1, embed = NULL, width = NULL, height = NULL, ...) {

  widget <-
    vegawidget(
      spec,
      embed = embed,
      width = width,
      height = height,
      ...
    )

  svg <- vw_to_svg(widget, scale = scale)

  svg
}

#' @rdname image
#' @export
#'
vw_to_svg.vegawidget <- function(widget, scale = 1, ...) {

  # just to be safe
  scale <- as.numeric(scale)

  js_string <-
    paste0(
     "var done = arguments[0];
      Vegawidget.findVewPromise('.vegawidget')
        .then(function(view) { return view.toSVG(", scale, "); })
        .then(function(svg) { done(svg) })
        .catch(function(err) { console.error(err) });"
    )

  svg <- get_image(widget, js_string)

  svg
}

#' @rdname image
#' @export
#'
vw_to_png <- function(...) {
  UseMethod("vw_to_png")
}

#' @rdname image
#' @export
#'
vw_to_png.default <-
  function(spec, scale = 1, embed = NULL, width = NULL, height = NULL, ...){

    widget <-
      vegawidget(
        spec,
        embed = embed,
        width = width,
        height = height,
        ...
      )

    png <- vw_to_png(widget, scale = scale)

    png
}

#' @rdname image
#' @export
#'
vw_to_png.vegawidget <- function(widget, scale = 1, ...) {

  # just to be safe
  scale <- as.numeric(scale)

  # NOTE
  #
  # We are supplying a "quality" argument to `toDataURL()`,
  # which is not defined for image/png in the HTML5 standard.
  #
  # However, not supplying a value results in a large, uncompressed
  # PNG string.
  #
  # This is noted here: https://github.com/ariya/phantomjs/issues/10455
  #
  # For the version of phantomJS that comes with webdriver/webshot,
  # the workaround of supplying a value for PNG works.
  #
  # In the issue, the problem is claimed to be fixed, but I don't know
  # if that fix is implemented in the packaged version of phantomJS,
  # or, if not, if the fix will mean that this workaround will stop working.
  #
  # If we start to get some large PNG files, this will be a place to look.

  js_string <-
    paste0(
      "var done = arguments[0];
       Vegawidget.findViewPromise('.vegawidget')
        .then(function(view){ return view.toCanvas(", scale, "); })
        .then(function(canvas) { return canvas.toDataURL('image/png', 0); })
        .then(done)
        .catch(function(err) { console.error(err) });"
    )

  png <- get_image(widget, js_string)

  png
}

#' Get image data
#'
#' Be warned: this function is not type-stable, and should
#' be used only internally to this package.
#'
#' @param widget    vegawidget
#' @param js_string Javascript string to extract image
#'
#' @return depends on `js_string` - could be SVG string or raw PNG data
#' @noRd
#'
get_image <- function(widget, js_string) {

  assert_packages("webdriver")

  html_file <- tempfile(pattern = "vegawidget-", fileext = ".html")
  htmlwidgets::saveWidget(widget, html_file)
  on.exit(unlink(html_file))

  pjs <- webdriver::run_phantomjs()
  ses <- webdriver::Session$new(port = pjs$port)
  ses$go(html_file)
  ses$setTimeout(500)
  img <- ses$executeScriptAsync(js_string)

  img
}
