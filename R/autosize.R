#' Autosize vegaspec
#'
#' The arguments `width` and `height` are used to override the width and height
#' of the provided `spec`, if the `spec` does not have multiple views.
#' The dimensions you provide describe the overall width and height of the
#' rendered chart, including axes, labels, legends, etc.
#'
#' In a Vega or Vega-Lite specification, the default interpretation
#' of width and height is to describe the dimensions of the
#' **data rectangle**, not including the space used by the axes, labels,
#' legends, etc. When `width` and `height` are specified using
#' [autosize](https://vega.github.io/vega-lite/docs/size.html#autosize),
#' the meanings of `width` and `height` change to describe the dimensions
#' of the **entire chart**, including axes, labels, legends, etc.
#'
#' There is an important limitation: specifying `width` and `height` is
#' [effective only for single-view and layered specifications](
#' https://vega.github.io/vega-lite/docs/size.html#limitations).
#' It will not work for specifications with multiple views
#' (e.g. `hconcat`, `vconcat`, `facet`, `repeat`); this will issue a
#' warning that there will be no effect on the specification when rendered.
#'
#' @inheritParams as_vegaspec
#' @param width   `integer`, if specified, the total rendered width (in pixels)
#'   of the chart - valid only for single-view charts and layered charts;
#'   the default is to use the width in the chart specification
#' @param height  `integer`, if specified, the total rendered height (in pixels)
#'   of the chart - valid only for single-view charts and layered charts;
#'   the default is to use the height in the chart specification
#'
#' @return S3 object with class `vegaspec`
#' @examples
#'   vw_autosize(spec_mtcars, width = 350, height = 350)
#' @seealso [Article on vegaspec (sizing)](https://vegawidget.github.io/vegawidget/articles/articles/vegaspec.html#sizing),
#'   [Vega documentation on sizing](https://vega.github.io/vega-lite/docs/size.html#autosize)
#' @export
#'
vw_autosize <- function(spec, width = NULL, height = NULL) {

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

.autosize.vegaspec_hconcat <- function(spec, width = NULL, height = NULL) {
  # the message that used to be here, and in the other autosize methods,
  # seemed too chatty
  NextMethod()
}

.autosize.vegaspec_vconcat <- function(spec, width = NULL, height = NULL) {
  NextMethod()
}

.autosize.vegaspec_concat <- function(spec, width = NULL, height = NULL) {
  NextMethod()
}

.autosize.vegaspec_facet <- function(spec, width = NULL, height = NULL) {
  NextMethod()
}

.autosize.vegaspec_repeat <- function(spec, width = NULL, height = NULL) {
  NextMethod()
}

.autosize.vegaspec_vega_lite <- function(spec, width = NULL, height = NULL) {

  if (is.null(c(width, height))) {
    # nothing to do here
    return(spec)
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

  spec$config$style <- list(cell = list(width = spec$width, height = spec$height))

  spec
}

