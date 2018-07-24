#' Determine vegaspec version
#'
#' Examines the `$schema` element of a vegaspec.
#'
#' Returns a list with two elements:
#'
#' \describe{
#'   \item{`library`}{`character`, either `"vega"` or `"vega_lite"`}
#'   \item{`version`}{`character`, version tag}
#' }
#'
#' @inheritParams as_vegaspec
#'
#' @return `list` with elements `library`, `version`
#' @examples
#'   spec_version(spec_mtcars)
#' @export
#'
spec_version <- function(spec) {

  spec <- as_vegaspec(spec)
  version <- .schema_type(spec[["$schema"]])

  version
}

.schema_type <- function(schema) {

  result <- list(library = "", version = "")

  regex <- ".*/schema/(vega|vega-lite)/v(.*)\\.json$"

  if (is.null(schema)) {
    stop("cannot determine schema type, input string is NULL", call. = FALSE)
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

  result$library <- gsub("-", "_", gsub(regex, "\\1", schema))
  result$version <- gsub(regex, "\\2", schema)

  result
}
