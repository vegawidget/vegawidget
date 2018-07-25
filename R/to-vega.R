#' Convert to Vega specification
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

.to_vega.vegaspec_vega_lite <- function(spec, ...) {

  # It is easy to do the wrong thing, converting between JSON and R objects.
  # Instead of using the V8 conversion, we use our functions for
  # the conversion: vw_as_json() and as_vegaspec().
  #
  # hence this tweet: https://twitter.com/ijlyttle/status/1019290316195627008

  assert_packages("V8")
  JS <- V8::JS
  ct <- V8::v8()

  str_vlspec <- vw_as_json(spec, pretty = FALSE)

  # load the vega-lite library (.vega_lite_js is internal package data)
  ct$eval(.vega_lite_js)

  # import the vega-lite JSON string, parse into JSON
  ct$assign('str_vlspec', str_vlspec)
  ct$assign('vlspec', JS('JSON.parse(str_vlspec)'))

  # compile into vega-lite, convert to JSON string
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



