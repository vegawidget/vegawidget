#' Write to SVG file
#'
#' @inheritParams to_svg
#' @param path path to which to write image-file
#'
#' @return copy of whatever was sent to it
#'
#' @examples
#' \dontrun{
#'   write_svg(vw_ex_mtcars)
#'   write_svg(vegawidget(vw_ex_mtcars))
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


#' Write to PNG file
#'
#' @inheritParams write_svg
#'
#' @return copy of whatever was sent to it
#'
#' @examples
#' \dontrun{
#'   write_svg(vw_ex_mtcars)
#'   write_svg(vegawidget(vw_ex_mtcars))
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
  png <- vw_png_bin(png)

  writeBin(png, fs::path_expand(path), endian = "big")

  invisible(spec)
}

#' @rdname write_png
#' @export
#'
write_png.vegawidget <- function(widget, path, scale = 1, ...) {

  png <- to_png(widget, scale = scale)
  png <- vw_png_bin(png)

  writeBin(png, fs::path_expand(path), endian = "big")

  invisible(vegawidget)
}

#' Translate PNG from dataURI string to binary
#'
#' @param png `character`, dataURI string describing PNG
#'
#' @return `raw` PNG
#' @keywords internal
#' @export
#'
vw_png_bin <- function(png) {

  # this should come along with webdriver
  assert_packages("base64enc")

  # strip the preamble
  png <- gsub("^.*,(.*)", "\\1", png)

  # convert to binary
  bin <- base64enc::base64decode(png)

  bin
}

