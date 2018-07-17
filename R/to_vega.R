#' Convert to a Vega specification
#'
#' @inheritParams as_vegaspec
#'
#' @return a vegaspec for Vega
#' @export
#'
to_vega <- function(spec) {
  .to_vega(as_vegaspec(spec))
}

# use internal S3 generic
.to_vega <- function(spec, ...) {
  UseMethod(".to_vega")
}

.to_vega.default <- function(spec, ...) {
  stop(".autosize(): no method for class ", class(spec), call. = FALSE)
}

.to_vega.vegaspec_vegalite <- function(spec, ...) {

  # it is easy to trip-up on the conversion between JSON and R objects,
  # so we write this to use our functions for the conversion,
  # as_character() and as_vegaspec().

  assert_packages("V8")
  JS <- V8::JS
  ct <- V8::v8()

  str_vlspec <- as_character(spec, pretty = FALSE)

  # load the vega-lite library (.vegalite_js is internal package data)
  ct$eval(.vegalite_js)

  # import the vegalite JSON string, parse into JSON
  ct$assign('str_vlspec', str_vlspec)
  ct$assign('vlspec', JS('JSON.parse(str_vlspec)'))

  # compile into vegalite, convert to JSON string
  ct$assign('vgspec', JS('vl.compile(vlspec).spec'))
  ct$assign('str_vgspec', JS('JSON.stringify(vgspec)'))

  # retrieve json string, convert to vegaspec
  str_vgspec <- ct$get('str_vgspec')
  vgspec <- as_vegaspec(str_vgspec)

  vgspec
}

.to_vega.vegaspec_vega <- function(spec, ...) {
   # do nothing, already a Vega spec
   spec
}



