#' Convert to Vega specification
#'
#' If you have  **[V8](https://CRAN.R-project.org/package=V8)** installed,
#' you can use this function to compile a Vega-Lite specification
#' into a Vega specification.
#'
#' @inheritParams as_vegaspec
#'
#' @return S3 object of class `vegaspec_vega` and `vegaspec`
#' @examples
#'   vw_spec_version(spec_mtcars)
#'   vw_spec_version(vw_to_vega(spec_mtcars))
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

  pkgfile <- function(...) {
    system.file("htmlwidgets", "lib", ..., package = "vegawidget")
  }

  assert_packages("V8")

  ct <- V8::v8()

  ct$source(pkgfile("vega", "vega.min.js"))
  ct$source(pkgfile("vega-lite", "vega-lite.min.js"))
  ct$eval(glue::glue("var vs = vegaLite.compile({vw_as_json(spec)})"))

  # don't let V8 convert to JSON; send as string
  ct$eval("var strSpec = JSON.stringify(vs.spec)")
  str_spec <- ct$get("strSpec")

  as_vegaspec(str_spec)
}

.vw_to_vega.vegaspec_vega <- function(spec, ...) {
   # do nothing, already a Vega spec
   spec
}

# Alternate way of doing this via V8
#ct <- V8::v8()
#ct$source(system.file('htmlwidgets','lib','vega','vega.min.js', package = "vegawidget"))
#ct$source(system.file('htmlwidgets','lib','vega-lite','vega-lite.min.js', package = "vegawidget"))
#ct$eval(glue::glue("var vs = vegaLite.compile({vw_as_json(spec_mtcars)})"))
#vs <- ct$get("vs")

