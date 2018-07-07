# these are the internal functions used to support vegaspec operations

as_json <- function(spec) {

  assert_packages("jsonlite")

  jsonlite::toJSON(spec, auto_unbox = TRUE, pretty = TRUE)
}

as_list <- function(spec) {

  assert_packages("jsonlite")

  jsonlite::fromJSON(spec)
}

