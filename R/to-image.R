#' Convert to SVG string
#'
#' @inheritParams vegawidget
#' @param scale scale factor for the image
#' @param widget object created using [vegawidget()]
#'
#' @return `character` SVG string
#' @examples
#' \dontrun{
#'   to_svg(vw_ex_mtcars)
#'   to_svg(vegawidget(vw_ex_mtcars))
#' }
#' @export
#'
to_svg <- function(...) {
  UseMethod("to_svg")
}

#' @rdname to_svg
#' @export
#'
to_svg.default <-
  function(spec, scale = 1, embed = NULL, width = NULL, height = NULL, ...) {

  widget <-
    vegawidget(
      spec,
      embed = embed,
      width = width,
      height = height,
      ...
    )

  svg <- to_svg(widget, scale = scale)

  svg
}

#' @rdname to_svg
#' @export
#'
to_svg.vegawidget <- function(widget, scale = 1, ...) {

  # just to be safe
  scale <- as.numeric(scale)

  js_string <-
    paste0(
     "var done = arguments[0];
      getVegaView('.vegawidget').toSVG(", scale, ")
        .then(function(svg) {
           done(svg)
        })
        .catch(function(err) {
          console.error(err)
        });"
    )

  svg <- get_image(widget, js_string)

  svg
}

#' Convert to PNG encoded-string
#'
#' @inheritParams to_svg
#'
#' @return `character` base-64 encoded string
#' @seealso [png_bin()]
#' @examples
#' \dontrun{
#'   to_png(vw_ex_mtcars)
#'   to_png(vegawidget(vw_ex_mtcars))
#' }
#' @export
#'
to_png <- function(...) {
  UseMethod("to_png")
}

#' @rdname to_png
#' @export
#'
to_png.default <-
  function(spec, scale = 1, embed = NULL, width = NULL, height = NULL, ...){

    widget <-
      vegawidget(
        spec,
        embed = embed,
        width = width,
        height = height,
        ...
      )

    png <- to_png(widget, scale = scale)

    png
}

#' @rdname to_png
#' @export
#'
to_png.vegawidget <- function(widget, scale = 1, ...) {

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
      getVegaView('.vegawidget').toCanvas(", scale, ")
        .then(function(canvas) {
           return canvas.toDataURL('image/png', 0);
        })
        .then(done)
        .catch(function(err) {
          console.error(err)
        });"
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
