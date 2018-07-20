#' write_svg
#'
#' Convert a vegaspec or a vegawidget into an SVG string
#'
#' @inheritParams vegawidget
#' @param path path to which to write image-file
#' @param scale scaleFactor for the image
#' @param widget object created using [vegawidget()]
#'
#' @return copy of whatever was sent to it
#'
#' @examples
#' \dontrun{
#'   write_svg(spec_mtcars)
#'   write_svg(vegawidget(spec_mtcars))
#' }
#' @export
#'
write_svg <- function(...) {
  UseMethod("write_svg")
}

#' @rdname write_svg
#' @export
#'
write_svg.default <- function(spec, path, scale = 1, embed = NULL,
                              width = NULL, height = NULL, ...) {

  svg <-
    to_svg(spec, scale = scale, embed = embed, width = width, height = height)

  writeLines(svg, fs::path_expand(path))

  spec
}

#' @rdname write_svg
#' @export
#'
write_svg.vegawidget <- function(widget, path, scale = 1, ...) {

  svg <- to_svg(widget, scale = scale)

  writeLines(svg, fs::path_expand(path))

}
