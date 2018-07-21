#' Write a vegaspec to an SVG file
#'
#' @inheritParams to_svg
#' @param path path to which to write image-file
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

  invisible(spec)
}

#' @rdname write_svg
#' @export
#'
write_svg.vegawidget <- function(widget, path, scale = 1, ...) {

  svg <- to_svg(widget, scale = scale)

  writeLines(svg, fs::path_expand(path))

  invisible(vegawidget)
}


#' Write a vegaspec to a PNG file
#'
#' @inheritParams write_svg
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
write_png <- function(...) {
  UseMethod("write_png")
}

#' @rdname write_png
#' @export
#'
write_png.default <- function(spec, path, scale = 1, embed = NULL,
                              width = NULL, height = NULL, ...) {

  png <-
    to_png(spec, scale = scale, embed = embed, width = width, height = height)

  png <- .as_bin(png)

  writeBin(png, fs::path_expand(path), endian = "big")

  invisible(spec)
}

#' @rdname write_png
#' @export
#'
write_png.vegawidget <- function(widget, path, scale = 1, ...) {

  png <- to_png(widget, scale = scale)

  png <- .as_bin(png)

  writeBin(png, fs::path_expand(path), endian = "big")

  invisible(vegawidget)
}

.as_bin <- function(x) {

  # this should come along with webdriver
  assert_packages("base64enc")

  # strip the preamble
  x <- gsub("^.*,(.*)", "\\1", x)

  # convert to binary
  x <- base64enc::base64decode(x)

  x
}

