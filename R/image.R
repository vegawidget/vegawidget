#' Write a spec to a png file
#'
#' This function has the side-effect of writing out an image file,
#' it returns an invisible copy of `spec` so that it can be part of a pipe.
#'
#' @inheritParams vegawidget
#' @param path `character` path to write to
#'
#' @return invisible copy of `spec`
#' @examples
#' \dontrun{
#'   write_png(spec_mtcars, "mtcars.png")
#' }
#'
#'
#' @export
#'
write_png <- function(spec, path, embed = NULL, width = NULL, height = NULL, ...) {

  # this inspired by the approach taken by vegalite:
  #  https://github.com/hrbrmstr/vegalite/blob/cdf7ee9c90bb71661ba00e20e7f6575acbf2e1c8/R/phantom.r

  # create a widget
  widget <-
    vegawidget(
      spec,
      embed = embed,
      width = width,
      height = height,
      elementId = "write-png",
      ...
    )

  # write widget to an html file
  file_widget_html <- tempfile(fileext = ".html")
  url_widget_html <- glue::glue("file://{file_widget_html}")
  htmlwidgets::saveWidget(widget, file = file_widget_html)

  # use webshot to take a picture
  file <-
    webshot::webshot(
      url_widget_html,
      file = fs::path_expand(path),
      selector = "#write-png .marks"
    )

  # return original spec
  invisible(spec)
}

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
  ct$eval(JS(.promise_js))
  ct$eval(JS(.symbol_js))
  ct$eval(JS(.vega_js))

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




