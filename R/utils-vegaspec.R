# these are the internal functions used to support vegaspec operations

as_json <- function(spec) {

  assert_packages("jsonlite")

  jsonlite::toJSON(spec, auto_unbox = TRUE, pretty = TRUE)
}

as_list <- function(spec) {

  assert_packages("jsonlite")

  jsonlite::fromJSON(spec)
}

#' Fix list for vegaspec
#'
#' It is shorthand to specify data as a data-frame; however we need to
#' capture these "shorthands" in the spec and replace it with
#' a list with a single element named `values`.
#'
#' @param spec `list` for a Vega/Vega-Lite spec
#'
#' @return `list`
#' @keywords internal
#' @export
#'
vegaspec_data_to_values <- function(spec) {
  mapply(data_to_values, spec, names(spec), SIMPLIFY = FALSE)
}

# workhorse for vegaspec_data_to_values
data_to_values <- function(.x, .name) {

  if (identical(.name, "datasets")) {
    # do nothing, this is the datasets branch
    .x <- .x
  } else if (identical(.name, "data") && is.data.frame(.x)) {
    # replace `data` element with a list with a `values` element
    .x <- list(values = .x)
  } else if (is.list(.x) || length(.x) > 1L) {

    # if .x has no names, use placeholders
    .names <- names(.x)
    if (is.null(.names)) {
      .names <- seq_along(.x)
    }

    # run again for each of the elements of x
    .x <- mapply(data_to_values, .x, .names, SIMPLIFY = FALSE)
  }

  .x
}

# could we impose on Alicia Schep to contribute this?
vegaspec_validate <- function(spec) {

  message("vegaspec_validate() is not yet active")

  spec
}
