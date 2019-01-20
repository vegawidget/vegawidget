#' Determine vegaspec version
#'
#' Use this function to determine the `library` and `version` of a `vegaspec`.
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
#'   vw_spec_version(spec_mtcars)
#' \dontrun{
#'   # requires nodejs to be installed
#'   vw_spec_version(vw_to_vega(spec_mtcars))
#' }
#' @export
#'
vw_spec_version <- function(spec) {

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


#' Create string for schema-URL
#'
#' Useful if you are creating a vegaspec manually.
#'
#' @param library `character`, either `"vega"` or `"vega_lite"`
#' @inheritParams vega_version
#'
#' @return `character` URL for schema
#' @examples
#'   vega_schema()
#'   vega_schema("vega", major = FALSE)
#'
#'   # creating a spec by hand
#'   spec <-
#'     list(
#'       `$schema` = vega_schema(),
#'       width = 300,
#'       height = 300
#'       # and so on
#'     ) %>%
#'     as_vegaspec()
#'
#' @export
#'
vega_schema <- function(library = c("vega_lite", "vega"), major = TRUE) {

  library <- match.arg(library)
  version <- vega_version(major = major)[[library]]

  # change "vega_lite" to "vega-lite"
  library <- gsub("_", "-", library)

  schema <-
    glue::glue("https://vega.github.io/schema/{library}/v{version}.json")
  schema <- as.character(schema)

  schema
}
