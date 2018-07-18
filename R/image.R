to_svg <- function(spec, scale = 1) {

  assert_packages("V8")
  JS <- V8::JS
  ct <- V8::v8()

  assertthat::assert_that(assertthat::is.number(scale))

  # convert to vega
  vgspec <- to_vega(spec)
  str_vgspec <- as_character(vgspec, pretty = FALSE)

  # call V8 to return svg
  # ref: https://vega.github.io/vega/docs/api/view/#view_toSVG

  # load the vega library (.vega_js is internal package data)
  ct$eval(JS(.vega_js))

  ct$source("https://vega.github.io/vega/assets/symbol.min.js")
  ct$source("https://vega.github.io/vega/assets/promise.min.js")
  ct$source("https://vega.github.io/vega/vega.js")

  # import the vegalite JSON string, parse into JSON
  ct$assign('str_vgspec', str_vgspec)
  ct$assign('vgspec', JS('JSON.parse(str_vgspec)'))

  ct$assign(
    'view',
    JS('new vega.View(vg.parse(vgspec)).renderer("none").initialize()')
  )

}



