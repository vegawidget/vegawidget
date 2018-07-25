#' Write to SVG file
#'
#' @inheritParams vw_to_svg
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
    vw_to_svg(
      spec,
      scale = scale,
      embed = embed,
      width = width,
      height = height
    )

  writeLines(svg, fs::path_expand(path))

  invisible(spec)
}

#' @rdname write_svg
#' @export
#'
write_svg.vegawidget <- function(widget, path, scale = 1, ...) {

  svg <- vw_to_svg(widget, scale = scale)

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
vw_write_png <- function(...) {
  UseMethod("vw_write_png")
}

#' @rdname vw_write_png
#' @export
#'
vw_write_png.default <- function(spec, path, scale = 1, embed = NULL,
                                 width = NULL, height = NULL, ...) {

  png <-
    vw_to_png(
      spec,
      scale = scale,
      embed = embed,
      width = width,
      height = height
    )
  png <- vw_png_bin(png)

  writeBin(png, fs::path_expand(path), endian = "big")

  invisible(spec)
}

#' @rdname vw_write_png
#' @export
#'
vw_write_png.vegawidget <- function(widget, path, scale = 1, ...) {

  png <- vw_to_png(widget, scale = scale)
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

