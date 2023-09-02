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

#' Get Vega JavaScript versions
#'
#' Use these functions to get which versions of Vega JavaScript libraries
#' are available. `vega_version_all()` returns a data frame showing all
#' versions included in this package, `vega_version_available()` returns
#' all versions available - subject to locking,
#' `vega_version()` shows the default version.
#'
#' This package offers multiple widgets, each corresponding to a major version
#' of Vega-Lite. Only one of these widgets can be used for a given loading of
#' this package. When `vegawidget()` is first called, the widget is "locked"
#' according to the `$schema` in the `vegaspec` used, or the default - the
#' most-recent version.
#'
#' \describe{
#'   \item{`is_locked`}{indicates if `vegawidget()` is has locked the version.}
#'   \item{`widget`}{indicates which version of the widget would be used.}
#' }
#'
#' @param major `logical` return major version-tags rather than the
#'   tags for the specific versions supported by this package
#'
#' @return \describe{
#'   \item{vega_version()}{`list` with elements: `is_locked`, `widget`,
#'     `vega_lite`, `vega`, `vega_embed`.}
#'   \item{vega_version_all()}{`data.frame` with elements: `widget`,
#'     `vega_lite`, `vega`, `vega_embed`.}
#'   \item{vega_version_available()}{`data.frame` with elements: `widget`,
#'     `vega_lite`, `vega`, `vega_embed`.}
#' }
#'
#' @examples
#'   vega_version()
#'   vega_version(major = TRUE)
#'   vega_version_all()
#'   vega_version_available()
#' @export
#'
vega_version <- function(major = FALSE) {

  x <- vega_version_all(major = major)
  x <- x[.vega_version_all == vw_env[["widget"]], ]
  x <- as.list(x)
  x[["is_locked"]] <- vw_env[["is_locked"]]

  x
}

#' @rdname vega_version
#' @export
#'
vega_version_all <- function(major = FALSE) {
  x <- .vega_version_all

  if (major) {
    x <- lapply(x, get_major)
    x <- as.data.frame(x)
  }

  x
}

#' @rdname vega_version
#' @export
#'
vega_version_available <- function(major = FALSE) {

  x <- vega_version(major = major)
  x_all <- vega_version_all(major = major)

  if (x$is_locked) {
    return(x_all[x_all[["widget"]] == x[["widget"]], ])
  }

  x_all
}

# function to return the major component
get_major <- function(x) {

  regexp <- "^\\d+"

  # predicate - if not string or does not begin with digit, return
  if (!is.character(x) || !all(grepl(regexp, x))) {
    return(x)
  }

  regmatches(x, regexpr(regexp, x))
}


#' Get the index of the candidate that matches the version
#'
#' @param version `character`
#' @param candidates `character` vector
#'
#' @return `list` with elements:
#'  - `index`: `integer` index of candidate that best matches version
#'  - `message`: `character`, if candidate not suitable (`NULL` if OK)
#' @examples
#'   get_candidate("5", c("5.2.0", "4.1.7")) # 1L
#'   get_candidate("4", c("5.2.0", "4.1.7")) # 2L
#'   get_candidate("6", c("5.2.0", "4.1.7")) # 1L, with warning
#'   get_candidate("3", c("5.2.0", "4.1.7")) # 2L, with warning
#'   get_candidate("5.21.0", c("5.21.0", "5.17.0")) # 1L
#'   get_candidate("5.01.0", c("5.21.0", "5.17.0")) # 1L
#'   get_candidate("5.22.0", c("5.21.0", "5.17.0")) # 1L, with warning
#'
#' @noRd
#'
get_candidate <- function(version, candidates) {

  # package_version needs to be vectorized
  package_major <- function(x) {
    package_version(x)$major
  }

  major <- function(x) {
    vapply(x, package_major, numeric(1), USE.NAMES = FALSE)
  }

  # need to save original for message
  v_orig <- version

  # if version has no ".", append a ".0" - so that numeric_version() will work
  if (!grepl("\\.", version)) {
    version <- glue::glue("{version}.0")
  }

  # if version smaller than smallest candidate, use smallest candidate
  if (major(version) < min(major(candidates))) {

    min_can <- min(candidates)

    return(
      list(
        index = match(min_can, candidates),
        message = glue::glue(
          "version {v_orig} smaller than minimum major-version available: {min_can}"
        )
      )
    )
  }

  # if version larger than largest candidate, use largest candidate
  if (major(version) > max(major(candidates))) {

    max_can <- max(candidates)

    return(
      list(
        index = match(max_can, candidates),
        message = glue::glue(
          "version {v_orig} larger than maximum major-version available: {max_can}"
        )
      )
    )
  }

  # get latest version with same major version
  can_at_major = candidates[major(version) == major(candidates)]

  list(
    index = match(max(can_at_major), candidates),
    message = NULL
  )
}

get_widget_string <- function(library, version, available) {

  library_with_underscore <- gsub("-", "_", library)

  candidates <- available[[library_with_underscore]]

  result <- get_candidate(version, candidates)

  widget <- available[["widget"]][result[["index"]]]

  if (!is.null(result[["message"]])) {
    warning(glue::glue("{library} {result[['message']]}"), call. = FALSE)
  }

  widget
}

vw_lock_set <- function(value) {
  vw_env[["is_locked"]] <- as.logical(value[[1]])
}

vw_widget_set <- function(value) {
  vw_env[["widget"]] <- as.character(value[[1]])
}

