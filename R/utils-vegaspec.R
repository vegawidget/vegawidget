# these are the internal functions used to support vegaspec operations

#' Write out a vegaspec as JSON
#'
#' @inheritParams as_vegaspec
#' @param pretty `logical` indicates to use pretty (vs. minified) formatting
#'
#' @return `vegaspec` object
#' @export
#'
as_json <- function(spec, pretty = TRUE) {

  spec <- as_vegaspec(spec)

  .as_json(unclass(spec), pretty = pretty)
}

.as_json <- function(un_spec, pretty = TRUE) {
  jsonlite::toJSON(un_spec, auto_unbox = TRUE, pretty = pretty)
}

as_list <- function(spec) {

  assert_packages("jsonlite")

  jsonlite::fromJSON(spec, simplifyVector = FALSE, simplifyDataFrame = TRUE)
}

