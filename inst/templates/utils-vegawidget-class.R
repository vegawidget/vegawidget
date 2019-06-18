#' @inheritParams vegawidget::as_vegaspec
#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.{{s3_class_name}} <- function(spec, ...) {

  # TODO: if needed, insert code to convert your object to
  # something that can be coerced to a vegaspec.
  #
  # e.g.:
  # spec <- spec$to_json()

  vegawidget::as_vegaspec(spec, ...)
}

#' @export
#'
print.{{s3_class_name}} <- function(x, ...) {

  x <- as_vegaspec(x)

  print(x, ...)
}

#' @export
#'
format.{{s3_class_name}} <- function(x, ...) {

  x <- as_vegaspec(x)

  format(x, ...)
}

#' @inheritParams vegawidget::knit_print.vegaspec
#' @rdname knit_print.vegaspec
#' @export
#'
knit_print.{{s3_class_name}} <- function(spec, ..., options = NULL) {

  spec <- as_vegaspec(spec)

  knitr::knit_print(spec, ..., options = options)
}
