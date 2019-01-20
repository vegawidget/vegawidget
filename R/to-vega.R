#' Convert to Vega specification
#'
#' If you have  **[nodejs](https://nodejs.org/en/)** installed,
#' you can use this function to compile a Vega-Lite specification
#' into a Vega specification.
#'
#' @inheritParams as_vegaspec
#'
#' @return S3 object of class `vegaspec_vega` and `vegaspec`
#' @examples
#'   vw_spec_version(spec_mtcars)
#' \dontrun{
#'   # requires nodejs to be installed
#'   vw_spec_version(vw_to_vega(spec_mtcars))
#' }
#' @export
#'
vw_to_vega <- function(spec) {
  .vw_to_vega(as_vegaspec(spec))
}

# use internal S3 generic
.vw_to_vega <- function(spec, ...) {
  UseMethod(".vw_to_vega")
}

.vw_to_vega.default <- function(spec, ...) {
  stop(".vw_to_vega(): no method for class ", class(spec), call. = FALSE)
}


.vw_to_vega.vegaspec_vega_lite <- function(spec, ...) {

  # Check dependencies
  assert_packages("processx")
  check_node_installed()

  # It is easy to do the wrong thing, converting between JSON and R objects.
  # So we use our functions for the conversion: vw_as_json() and as_vegaspec().
  #
  # hence this tweet: https://twitter.com/ijlyttle/status/1019290316195627008

  str_vlspec <- vw_as_json(spec, pretty = FALSE)

  # Write the spec to a temporary file
  spec_path <- tempfile(fileext = ".json")
  cat(str_vlspec, file = spec_path)

  # Get the package location -- used as argument
  pkg_path <- system.file(package = "vegawidget")

  # Get the script location for the node script that does stuff
  script_path <-  system.file("bin/compile_spec.js", package = "vegawidget")

  # Use processx to run the script
  res <- processx::run("node", args = c(script_path, pkg_path, spec_path))

  str_vgspec <- res$stdout

  vgspec <- as_vegaspec(str_vgspec)

  vgspec
}

.vw_to_vega.vegaspec_vega <- function(spec, ...) {
   # do nothing, already a Vega spec
   spec
}



