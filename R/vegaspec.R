#' Coerce to a Vega/Vega-Lite specification
#'
#' Talk about how `vegaspec` is a thin wrapper to `list`. Implemented as JSON.
#'
#' Talk about this is the chance to validate the spec and to consolidate the
#' datasets.
#'
#' @param spec        object to be coerced to Vega/Vega-Lite specification
#' @param validate    `logical` indicates to validate the specification
#' @param consolidate `logical` indicates to consolidate data into
#'   top-level `datasets`
#'
#' @return S3 object of class `vegaspec`
#' @export
#'
as_vegaspec <- function(spec, validate = TRUE, consolidate = TRUE) {
  UseMethod("as_vegaspec")
}

as_vegaspec.default <- function(spec, validate = TRUE, consolidate = TRUE) {

  warning("as_vegaspec(): no method for class ", class(spec), call. = FALSE)

  spec
}

as_vegaspec.vegaspec <- function(spec, validate = TRUE, consolidate = TRUE) {
  NextMethod()
}

as_vegaspec.list <- function(spec, validate = TRUE, consolidate = TRUE) {

  # print("list")

  # take care of data-frames specified as data, rather than as data$values
  spec <- vegaspec_data_to_values(spec)

  if (consolidate) {
    spec <- vegaspec_consolidate(spec)
  }

  if (validate) {
    spec <- vegaspec_validate(spec)
  }

  # fix data with data frames

  spec <- structure(spec, class = unique(c("vegaspec", class(spec))))
}

as_vegaspec.json <- function(spec, validate = TRUE, consolidate = TRUE) {

  # print("json")

  # convert to list, process
  spec <- as_list(spec)

  as_vegaspec(spec, validate = validate, consolidate = consolidate)
}

as_vegaspec.character <- function(spec, validate = TRUE, consolidate = TRUE) {

  # print("character")

  # validate the input
  assertthat::assert_that(
    jsonlite::validate(spec),
    msg = "spec is not valid JSON"
  )

  # convert to list, process
  spec <- as_list(spec)

  as_vegaspec(spec, validate = validate, consolidate = consolidate)
}

