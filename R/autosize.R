#' Autosize a vegaspec
#'
#' @inheritParams as_vegaspec
#' @param width, `integer` total width (pixels)
#' @param height, `integer` total height (pixels)
#'
#' @return object with S3 class `vegaspec`
#' @examples
#'   autosize(spec_mtcars, width = 350, height = 350)
#' @export
#'
autosize <- function(spec, width = NULL, height = NULL) {

  spec <- as_vegaspec(spec)

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

  `%||%` <- rlang::`%||%`
  # using this notation:
  #  spec$config <- spec$config %||% list()
  #
  # to create a new list only if needed, so as not to
  # wipe out any parameters in an existing list

  spec$config <- spec$config %||% list()

  spec$config$autosize <- spec$config$autosize %||% list()
  spec$config$autosize$contains <- "padding"
  spec$config$autosize$type <- "fit"

  spec$config$view <- spec$config$view %||% list()
  spec$config$view$width <- width
  spec$config$view$height <- height

  spec
}

is_multiple_view <- function(spec) {

  spec <- as_vegaspec(spec)

  names_multiple_view <- c("facet", "repeat", "hconcat", "vconcat")

  any(names_multiple_view %in% names(spec))
}
