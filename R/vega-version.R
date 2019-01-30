#' Get versions of Vega JS libraries
#'
#' This is an internal function for updating this package.
#'
#' @param vega_lite_version `character` version of Vega-Lite, e.g. `"2.5.0"`
#'
#' @return `list` with elements `vega_lite`, `vega`, `vega_embed`
#'
#' @examples
#' \dontrun{
#'   # requires network-access
#'   get_vega_version(vega_lite_version = "2.5.0")
#' }
#' @keywords internal
#' @noRd
#'
get_vega_version <- function(vega_lite_version) {

  if (!requireNamespace("glue", quietly = TRUE)) {
    stop("Package \"glue\" needed for this function to work. Please install it.",
         call. = FALSE)
  }

  if (!requireNamespace("httr", quietly = TRUE)) {
    stop("Package \"httr\" needed for this function to work. Please install it.",
         call. = FALSE)
  }

  url <-
    glue::glue("https://cdn.jsdelivr.net/npm/vega-lite@{vega_lite_version}/package.json")

  # get and validate response
  resp <- httr::GET(url)
  resp <- httr::stop_for_status(
    resp,
    task = paste("retrieve Vega-Lite manifest at", url, " - please verify")
  )

  # parse response
  text <- httr::content(resp, as = "text")
  package <- jsonlite::fromJSON(text)

  # get versions
  vega_version <- sub("\\^", "", package$devDependencies$vega)
  vega_embed_version <- sub("\\^", "", package$devDependencies$`vega-embed`)

  vega_version <- list(
    vega_lite = vega_lite_version,
    vega = vega_version,
    vega_embed = vega_embed_version
  )

  vega_version
}

#' Determine Vega JavaScript versions
#'
#' @param major `logical` return major version-tags rather than the
#'   tags for the specific versions supported by this package
#'
#' @return `list` with `character` elements
#'   named `vega_lite`, `vega`, `vega_embed`
#' @examples
#'   vega_version()
#'   vega_version(major = TRUE)
#' @export
#'
vega_version <- function(major = FALSE) {

  x <- .vega_version

  if (major) {
    x <- lapply(x, get_major)
  }

  x
}

# function to return the major component
get_major <- function(x) {
  regmatches(x, regexpr("^\\d+", x))
}

