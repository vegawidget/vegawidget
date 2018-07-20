#' Coerce to a Vega/Vega-Lite specification
#'
#' Talk about how `vegaspec` is a thin wrapper to `list`. Implemented as JSON.
#'
#' Talk about this is the chance to validate the spec.
#'
#' @param spec        object to be coerced to Vega/Vega-Lite specification
#' @param ...         other args (attempt to future-proof)
#'
#' @return S3 object of class `vegaspec`
#' @export
#'
as_vegaspec <- function(spec, ...) {
  UseMethod("as_vegaspec")
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.default <- function(spec, ...) {
  stop("as_vegaspec(): no method for class ", class(spec), call. = FALSE)
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.vegaspec <- function(spec, ...) {
  spec
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.list <- function(spec, ...) {
  spec <- .as_vegaspec(spec)
  spec
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.json <- function(spec, ...) {
  spec <- .as_list(spec)
  spec <- .as_vegaspec(spec)
  spec
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.character <- function(spec, ...) {

  is_url <- rlang::is_string(spec) && grepl("^http(s?)://", spec)
  is_con <- rlang::is_string(spec) && file.exists(spec)

  # remote file
  if (is_url) {
    assert_packages("httr")
    spec <- httr::GET(spec)
    spec <- httr::stop_for_status(spec)
    spec <- httr::content(spec, as = "text", encoding = "UTF-8")
  }

  # local file
  if (is_con) {
    spec <- readLines(spec, warn = FALSE)
  }

  spec <- .as_json(spec)
  spec <- .as_list(spec)
  spec <- .as_vegaspec(spec)
  spec
}

#' Convert vegaspec to JSON
#'
#' @inheritParams as_vegaspec
#' @param pretty `logical` indicates to use pretty (vs. minified) formatting
#'
#' @return `jsonlite::json` object
#' @examples
#'   as_json(spec_mtcars)
#' @export
#'
as_json <- function(spec, pretty = TRUE) {

  spec <- as_vegaspec(spec)
  spec <- .as_json(spec, pretty = pretty)

  spec
}





