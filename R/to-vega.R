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

  # determine versions of vega, vega-lite
  version_all <- vega_version_all()
  spec_version <- vw_spec_version(spec)
  widget <-
    get_widget_string(
      spec_version[["library"]],
      spec_version[["version"]],
      version_all
    )

  version_widget <- version_all[version_all[["widget"]] == widget, ]
  version_vega <- version_widget[["vega"]]
  version_vega_lite <- version_widget[["vega_lite"]]

  ct$source(pkgfile("vega", glue::glue("vega@{version_vega}.min.js")))
  ct$source(
    pkgfile("vega-lite", glue::glue("vega-lite@{version_vega_lite}.min.js"))
  )
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

