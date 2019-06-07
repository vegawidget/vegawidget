#' Coerce to vegaspec
#'
#' See \code{vegawidget::\link[vegawidget]{as_vegaspec}} for details.
#'
#' @inheritParams vegawidget::as_vegaspec
#' @return S3 object of class `vegaspec`
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

#' @rdname knit_print.vegaspec
#' @export
#'
knit_print.{{s3_class_name}} <- function(spec, ..., options = NULL) {

  spec <- as_vegaspec(spec)

  knitr::knit_print(spec, ..., options = options)
}
