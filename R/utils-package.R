#' Assert that packages are loaded
#'
#' This function can be useful in writing package functions that use
#' functions from packages that you "suggest". It asserts that these packages
#' are available, and throws an informative error for those packages
#' that are not.
#'
#' @param packages `character` vector of package names to check
#'
#' @return `logical` indicating success
#' @examples
#' \dontrun{
#'   assert_packages(c("base", "utils"))
#' }
#' @seealso [R Packages book](http://r-pkgs.had.co.nz/description.html#dependencies)
#' @keywords internal
#'
#'
assert_packages <- function(packages) {

  is_missing <-
    vapply(packages, function(x) {!requireNamespace(x, quietly = TRUE)}, TRUE)

  missing_pkgs <- packages[is_missing]

  quote_missing_pkgs <-
    vapply(missing_pkgs, function(x) {paste0('"', x, '"')}, "")

  assertthat::assert_that(
    identical(length(missing_pkgs), 0L),
    msg = paste(
      "Package(s):",
      paste(quote_missing_pkgs, collapse = ", "),
      "needed for this function to work. Please install.",
      sep = " "
    )
  )

}

