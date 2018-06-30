# these are the internal functions used to support vegaspec operations

as_json <- function(spec) {

  assert_packages("jsonlite")

  jsonlite::toJSON(spec, auto_unbox = TRUE, pretty = TRUE)
}

as_list <- function(spec) {

  assert_packages("jsonlite")

  jsonlite::fromJSON(spec)
}

vegaspec_consolidate_data <- function(spec) {

  message("vegaspec_consolidate_data() is not yet active")

  spec
}

# could we impose on Alicia Schep to contribute this?
vegaspec_validate <- function(spec) {

  message("vegaspec_validate() is not yet active")

  spec
}
