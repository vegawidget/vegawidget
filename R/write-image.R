#' @rdname image
#' @export
#'
vw_write_svg <- function(spec, path, ...) {

  svg <-
    vw_to_svg(
      spec, ...
    )

  writeLines(svg, fs::path_expand(path))

  invisible(spec)
}

#' @rdname image
#' @export
#'
vw_write_png <- function(
  spec, path, width = NULL, height = NULL, dpi = NULL, ...) {

  bm <-
    vw_to_bitmap(
      spec,
      width = width,
      height = height
    )

  png::writePNG(bm, target =  path, dpi = dpi)
  invisible(spec)
}
