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

  url <-
    glue::glue("https://cdn.jsdelivr.net/npm/vega-lite@{vega_lite_version}/package.json")

  package <- jsonlite::fromJSON(url)

  # get versions
  vega_version <- sub("\\^", "", package$peerDependencies$vega)
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

