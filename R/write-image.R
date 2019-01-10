#' @rdname image
#' @export
#'
vw_write_svg <- function(spec, path, width = NULL, height = NULL, ...) {

  assert_packages("fs")

  svg <- vw_to_svg(spec, width = width, height = height, ...)

  writeLines(svg, fs::path_expand(path))

  invisible(spec)
}

#' @rdname image
#' @export
#'
vw_write_png <- function(spec, path, scale = 1, width = NULL, height = NULL,
                         ...) {

  assert_packages("fs", "png")

  bm <- vw_to_bitmap(spec, scale = scale, width = width, height = height, ...)

  png::writePNG(bm, fs::path_expand(path))

  invisible(spec)
}
