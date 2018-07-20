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

#' to_svg
#'
#' Turn a spec into an svg
#' @inheritParams vegawidget
#' @param scale scaleFactor
#' @export
to_svg <- function(spec, scale = 1, embed = NULL, width = NULL, height = NULL, ...){

  widget <-
    vegawidget(
      spec,
      embed = embed,
      width = width,
      height = height,
      elementId = "write-svg",
      ...
    )

  html_file <- tempfile(pattern = "vegawidget-", fileext = ".html")
  htmlwidgets::saveWidget(widget, html_file)
  on.exit(unlink(html_file))

  pjs <- webdriver::run_phantomjs()
  ses <- webdriver::Session$new(port = pjs$port)
  ses$go(html_file)
  ses$setTimeout(500)
  svg <- ses$executeScriptAsync(paste0("var done = arguments[0];
                                getVegaView('write-svg').toSVG(",scale,").then(function(svg){done(svg)}).catch(function(err) {console.error(err)});"))
  return(svg)
}




