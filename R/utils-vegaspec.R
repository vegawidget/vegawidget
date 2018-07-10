# these are the internal functions used to support vegaspec operations

as_json <- function(spec, pretty = TRUE) {

  assert_packages("jsonlite")

  jsonlite::toJSON(spec, auto_unbox = TRUE, pretty = pretty)
}

as_list <- function(spec) {

  assert_packages("jsonlite")

  jsonlite::fromJSON(spec)
}

