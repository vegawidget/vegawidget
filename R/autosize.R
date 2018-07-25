#' Autosize vegaspec
#'
#' The arguments `width` and `height` can be used to override the width and height
#' of the provided `spec`.
#'
#' There are some important limitations:
#'
#' - Specifying `width` and `height` is
#' [effective only for single-view and layered specifications](
#' https://vega.github.io/vega-lite/docs/size.html#limitations).
#' It will not work for specifications with multiple views
#' (e.g. `hconcat`, `vconcat`, `facet`, `repeat`); this will issue a
#' warning that there will be no effect on the specification when rendered.
#'
#' - In the specification, the default interpretation of width and height
#' is to describe the dimensions of the
#' **plotting rectangle**, not including the space used by the axes, labels,
#' etc. When `width` and `height` are specified,
#' the meanings change to describe the dimensions of the **entire** rendered chart,
#' including axes, labels, etc.
#'
#' @inheritParams as_vegaspec
#' @param width   `integer`, if specified, the total rendered width (in pixels)
#'   of the chart - valid only for single-view charts and layered charts;
#'   the default is to use the width in the chart specification
#' @param height  `integer`, if specified, the total rendered height (in pixels)
#'   of the chart - valid only for single-view charts and layered charts;
#'   the default is to use the height in the chart specification
#'
#' @return object with S3 class `vegaspec`
#' @examples
#'   autosize(vw_ex_mtcars, width = 350, height = 350)
#' @export
#'
autosize <- function(spec, width = NULL, height = NULL) {

  # validate and assign class
  spec <- as_vegaspec(spec)
  spec <- .autosize(spec, width, height)

  spec
}

.autosize <- function(spec, ...) {
  UseMethod(".autosize")
}

.autosize.default <- function(spec, ...) {
  stop(
    ".autosize(): no method for class ",
    paste(class(spec), collapse = " "),
    call. = FALSE)
}

.autosize.vegaspec_vega_lite <- function(spec, width = NULL, height = NULL) {

  if (is.null(c(width, height))) {
    # nothing to do here
    return(spec)
  }

  # if this spec has multiple views, warn that autosize will not work
  if (is_multiple_view(spec)) {
    warning(
      "Specifying the width or height of a ",
      "vegaspec with multiple views has no effect on rendering."
    )
  }

  # using this notation: spec$config <- spec$config %||% list()
  #
  # to create a new list only if needed, so as not to
  # wipe out any parameters in an existing list

  spec$width <- as.integer(width %||% spec$width)
  spec$height <- as.integer(height %||% spec$height)

  spec$config <- spec$config %||% list()
  spec$config$autosize <- spec$config$autosize %||% list()
  spec$config$autosize$type <- "fit"
  spec$config$autosize$contains <- "padding"

  spec$config$view <- spec$config$view %||% list()
  spec$config$view$width <- spec$width
  spec$config$view$height <- spec$height

  spec
}

.autosize.vegaspec_vega <- function(spec, width = NULL, height = NULL) {

  if (is.null(c(width, height))) {
    # nothing to do here
    return(spec)
  }

  spec$width <- as.integer(width %||% spec$width)
  spec$height <- as.integer(height %||% spec$height)

  spec$autosize <- list(type = "fit", contains = "padding")

  spec$config <- spec$config %||% list()
  spec$config$autosize <- spec$autosize

  spec
}

is_multiple_view <- function(spec) {

  spec <- as_vegaspec(spec)

  names_multiple_view <- c("facet", "repeat", "hconcat", "vconcat")

  any(names_multiple_view %in% names(spec))
}
