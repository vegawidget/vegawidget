#' Determine library and version of a vegaspec
#'
#' Examines the `$schema` element of a vegaspec.
#'
#' Returns a list with two elements:
#'
#' \describe{
#'   \item{`library`}{`character`, either `"vega"` or `"vegalite"`}
#'   \item{`version`}{`character`, version tag}
#' }
#'
#' @inheritParams as_vegaspec
#'
#' @return named `list`
#' @examples
#'   vegaspec_type(spec_mtcars)
#' @export
#'
vegaspec_type <- function(spec) {

  spec <- as_vegaspec(spec)
  type <- .spec_type(unclass(spec))

  type
}

#' Determine library and version of spec
#'
#' @noRd
#'
#' @param spec vegaspec - has to be in list form
#'
.spec_type <- function(list_spec) {

  .schema_type(list_spec[["$schema"]])

}

.schema_type <- function(schema) {

  result <- list(library = "", version = "")

  regex <- ".*/schema/(vega|vega-lite)/v(.*)\\.json$"

  if (is.null(schema)) {
    stop("cannot determine schema type, input string is NULL", call. = FALSE)
    return(result)
  }

  has_schema <- grepl(regex, schema)
  if (!has_schema) {
    warning(
      "cannot determine schema type from input string: ",
      schema,
      call. = FALSE
    )
    return(result)
  }

  result$library <- gsub("-", "", gsub(regex, "\\1", schema))
  result$version <- gsub(regex, "\\2", schema)

  result
}
