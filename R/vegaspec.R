#' Coerce to a Vega/Vega-Lite specification
#'
#' @param spec             object to be coerced to Vega/Vega-Lite specification
#' @param validate_spec     `logical` indicates to validate_spec the specification
#' @param convert_data     `logical` indicates to convert any `data.frame` to JSON
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

as_vegaspec.json <- function(spec, validate_spec = TRUE, convert_data = TRUE,
                             consolidate_data = TRUE) {

  # print("json")

  # if we want to convert or consolidate data,
  #  convert it to a list, make the changes
  if (convert_data || consolidate_data) {
    spec <- as_list(spec)

    # calling with validate_spec FALSE to avoid calling the validation twice
    spec <-
      as_vegaspec(
        spec,
        validate_spec = FALSE,
        convert_data = convert_data,
        consolidate_data = consolidate_data
      )
  }

  # validate
  if (validate_spec) {
    spec <- vegaspec_validate(spec)
  }

  spec
}

as_vegaspec.list <- function(spec, validate_spec = TRUE, convert_data = TRUE,
                             consolidate_data = TRUE) {

  # print("list")

  # consolidate and convert data, if requested

  if (consolidate_data) {
    spec <- vegaspec_consolidate_data(spec)
  }

  if (convert_data) {
    spec <- vegaspec_convert_data(spec)
  }

  # convert to json and call json method.
  # note that we are setting the convert and consolidate flags to FALSE
  # to avoid calling repeatedly

  spec <- as_json(spec)

  as_vegaspec(
    spec,
    validate_spec = validate_spec,
    convert_data = FALSE,
    consolidate_data = FALSE
  )
}

as_vegaspec.character <- function(spec, validate_spec = TRUE,
                                  convert_data = TRUE,
                                  consolidate_data = TRUE) {

  # print("character")

  # this assumes that the character vector is JSON,
  #  so we convert to list, then list will convert to "proper" JSON
  spec <- as_list(spec)

  as_vegaspec(
    spec,
    validate_spec = validate_spec,
    convert_data = convert_data,
    consolidate_data = consolidate_data
  )
}

