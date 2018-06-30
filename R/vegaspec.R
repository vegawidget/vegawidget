#' Coerce to a Vega/Vega-Lite specification
#'
#' @param spec             object to be coerced to Vega/Vega-Lite specification
#' @param validate_spec    `logical` indicates to validate_spec the specification
#' @param consolidate_data `logical` indicates to consolidate data into
#'   top-level `datasets`
#'
#' @return `json`
#'
as_vegaspec <- function(spec, validate_spec = TRUE, convert_data = TRUE,
                        consolidate_data = TRUE) {
  UseMethod("as_vegaspec")
}

as_vegaspec.default <- function(spec, validate_spec = TRUE, convert_data = TRUE,
                        consolidate_data = TRUE) {

  warning("as_vegaspec(): no method for class ", class(spec), call. = FALSE)

  spec
}

as_vegaspec.json <- function(spec, validate_spec = TRUE,
                             consolidate_data = TRUE) {

  # print("json")

  # convert to list, process
  spec <- as_list(spec)

  as_vegaspec(
    spec,
    validate_spec = validate_spec,
    consolidate_data = consolidate_data
  )
}

as_vegaspec.list <- function(spec, validate_spec = TRUE,
                             consolidate_data = TRUE) {

  # print("list")

  if (consolidate_data) {
    spec <- vegaspec_consolidate_data(spec)
  }

  spec <- as_json(spec)

  # validate
  if (validate_spec) {
    spec <- vegaspec_validate(spec)
  }

  spec
}

as_vegaspec.character <- function(spec, validate_spec = TRUE,
                                  consolidate_data = TRUE) {

  # print("character")

  # validate the input
  assertthat::assert_that(
    jsonlite::validate(spec),
    msg = "spec is not valid JSON"
  )

  # convert to list, process
  spec <- as_list(spec)

  as_vegaspec(
    spec,
    validate_spec = validate_spec,
    consolidate_data = consolidate_data
  )
}

