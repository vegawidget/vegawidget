#' Coerce to vegaspec
#'
#' Vega and Vega-Lite use JSON as their specification-format. Within R,
#' it seems natural to work with these specifications as lists. Accordingly,
#' a `vegaspec` is also a list. This family of functions is used to coerce lists,
#' JSON, and character strings to `vegaspec`.
#'
#' The `character` method for this function will take:
#' \itemize{
#'   \item{JSON string}
#'   \item{A path to a local JSON file}
#'   \item{A URL that contains a JSON file, requires that [httr](https://CRAN.R-project.org/package=httr) be installed}
#' }
#'
#' For Vega and Vega-Lite, the translation between lists and JSON is a little
#' bit particular. This function, [as_vegaspec()], can be used to translate
#' from JSON; [vw_as_json()] can be used to translate to JSON.
#'
#' You can use the function [vw_spec_version()] to determine if a `vegaspec` is built for
#' Vega-Lite or Vega. You can use [vw_to_vega()] to translate a Vega-Lite spec to Vega.
#'
#' @param spec        object to be coerced to `vegaspec`, a Vega/Vega-Lite specification
#' @param ...         other args (attempt to future-proof)
#'
#' @return S3 object of class `vegaspec`
#' @examples
#'   spec <- list(
#'     `$schema` = vega_schema(),
#'     data = list(values = mtcars),
#'     mark = "point",
#'     encoding = list(
#'       x = list(field = "wt", type = "quantitative"),
#'       y = list(field = "mpg", type = "quantitative"),
#'       color = list(field = "cyl", type = "nominal")
#'     )
#'   )
#'
#'   as_vegaspec(spec)
#'
#'   \dontrun{
#'     # requires network-access
#'     as_vegaspec("https://vega.github.io/vega-lite/examples/specs/bar.vl.json")
#'   }
#' @seealso [Vega](https://vega.github.io/vega/),
#'   [Vega-Lite](https://vega.github.io/vega-lite/),
#'   [vw_as_json()], [vw_spec_version()], [vw_to_vega()]
#' @export
#'
as_vegaspec <- function(spec, ...) {
  UseMethod("as_vegaspec")
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.default <- function(spec, ...) {
  stop("as_vegaspec(): no method for class ", class(spec), call. = FALSE)
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.vegaspec <- function(spec, ...) {
  spec
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.list <- function(spec, ...) {
  spec <- .as_vegaspec(spec)
  spec
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.json <- function(spec, ...) {
  spec <- .as_list(spec)
  spec <- .as_vegaspec(spec)
  spec
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.character <- function(spec, ...) {

  is_url <- rlang::is_string(spec) && grepl("^http(s?)://", spec)
  is_con <- rlang::is_string(spec) && file.exists(spec)

  # remote file
  if (is_url) {
    assert_packages("httr")
    spec <- httr::GET(spec)
    spec <- httr::stop_for_status(spec)
    spec <- httr::content(spec, as = "text", encoding = "UTF-8")
  }

  # local file
  if (is_con) {
    spec <- readLines(spec, warn = FALSE)
  }

  spec <- .as_json(spec)
  spec <- .as_list(spec)
  spec <- .as_vegaspec(spec)
  spec
}

#' @rdname as_vegaspec
#' @export
#'
as_vegaspec.vegawidget <- function(spec, ...) {
  # Pull out the spec from a widget object
  spec <- .as_list(spec$x)$chart_spec
  .as_vegaspec(spec)
}


#' Coerce vegaspec to JSON
#'
#' For Vega and Vega-Lite, the translation between lists and JSON is a little
#' bit particular. This function, [vw_as_json()], can be used to translate
#' to JSON; [as_vegaspec()] can be used to translate from JSON.
#'
#' @inheritParams as_vegaspec
#' @param pretty `logical` indicates to use pretty (vs. minified) formatting
#'
#' @return `jsonlite::json` object
#' @examples
#'   vw_as_json(spec_mtcars)
#'
#' @seealso [as_vegaspec()]
#' @export
#'
vw_as_json <- function(spec, pretty = TRUE) {

  spec <- as_vegaspec(spec)
  spec <- .as_json(spec, pretty = pretty)

  spec
}





