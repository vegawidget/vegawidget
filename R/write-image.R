#' @rdname image
#' @export
#'
vw_write_svg <- function(...) {
  UseMethod("vw_write_svg")
}

#' @rdname image
#' @export
#'
vw_write_svg.default <- function(spec, path, scale = 1, embed = NULL,
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

#' @rdname image
#' @export
#'
vw_write_svg.vegawidget <- function(widget, path, scale = 1, ...) {

  svg <- vw_to_svg(widget, scale = scale)

  writeLines(svg, fs::path_expand(path))

  invisible(vegawidget)
}


#' @rdname image
#' @export
#'
vw_write_png <- function(...) {
  UseMethod("vw_write_png")
}

#' @rdname image
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

#' @rdname image
#' @export
#'
vw_write_png.vegawidget <- function(widget, path, scale = 1, ...) {

  png <- vw_to_png(widget, scale = scale)
  png <- vw_png_bin(png)

  writeBin(png, fs::path_expand(path), endian = "big")

  invisible(vegawidget)
}

#' Coerce data-URI string to raw binary
#'
#' [vw_to_png()] returns a data-URI string for the PNG image. If
#' you want this PNG image as `raw` binary data, use `vw_to_png()` followed
#' this function.
#'
#' @param png `character`, data-URI string describing PNG
#'
#' @return `raw` PNG
#' @examples
#' \dontrun{
#'    spec_mtcars %>% vw_to_png() %>% vw_png_bin()
#' }
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

