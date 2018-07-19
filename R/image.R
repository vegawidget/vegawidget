
# this does *NOT* work
to_svg <- function(spec, scale = 1) {

  assert_packages("V8")
  JS <- V8::JS
  ct <- V8::v8()

  assertthat::assert_that(assertthat::is.number(scale))

  # convert to vega
  vgspec <- to_vega(spec)
  str_vgspec <- as_json(vgspec, pretty = FALSE)

  # call V8 to return svg
  # ref: https://vega.github.io/vega/docs/api/view/#view_toSVG

  # load the vega library (.vega_js is internal package data)

  ct$eval('function setTimeout(){}') # hacky
  ct$eval(JS(vegawidget:::.promise_js))
  ct$eval(JS(vegawidget:::.symbol_js))
  ct$eval(JS(vegawidget:::.vega_js))

  # import the vegalite JSON string, parse into JSON
  ct$assign('str_vgspec', str_vgspec)
  ct$assign('vgspec', JS('JSON.parse(str_vgspec)'))

  ct$assign(
    'view',
    JS('new vega.View(vega.parse(vgspec))
                .renderer("none")
                .initialize()
                .finalize()')
  )

  ct$assign('svg', JS('view.toSVG().then(function(svg){svg})'))

}



