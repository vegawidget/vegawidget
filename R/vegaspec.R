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

  warning("as_vegaspec(): no method for class ", class(spec), call. = FALSE)

  spec
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
  spec <- structure(spec, class = unique(c("vegaspec", class(spec))))

  spec
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.json <- function(spec, ...) {

  # convert to list, process
  spec <- as_list(spec)

  as_vegaspec(spec)
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.character <- function(spec, ...) {

  is_url <- rlang::is_string(spec) && grepl("^http(s?)://", spec)

  if (is_url) {
    spec <- httr::GET(spec)
    spec <- httr::stop_for_status(spec)
    spec <- httr::content(spec, as = "text", encoding = "UTF-8")
  }

  # validate the input
  assertthat::assert_that(
    jsonlite::validate(spec),
    msg = "spec is not valid JSON"
  )

  # convert to list, process
  spec <- as_list(spec)

  as_vegaspec(spec)
}

