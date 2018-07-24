#' Create a Vega/Vega-Lite htmlwidget
#'
#' Renders a chart as an htmlwidget.
#'
#' This function is called `vegawidget()` is because it returns an htmlwidget
#' that uses Vega-Lite and Vega JavaScript libraries.
#'
#' To specify embedding-options, use the [vega_embed()] function with the
#' `embed` argument. Its most-important options are:
#'
#' - `renderer`, to specify `"canvas"` (default) or `"svg"`
#' - `actions`,  to specify action-links
#'    for `export`, `source`, `compiled`, and `editor`
#'
#' If `actions` is `TRUE` (or `FALSE`), all the links
#' are shown (or not). Use a named list to be more specific, see
#' [vega_embed()].
#'
#' If `embed` is `NULL`, `vegawidget()` sets `embed` to the value of
#' `getOption("vega.embed")`. Then, if this option is `NULL`, the
#' [vega-embed](https://github.com/vega/vega-embed#api-reference)
#' defaults are used.
#'
#' The arguments `width` and `height` are used to override the width and height
#' determined using the `chart` specification. However, there are some
#' important provisions:
#'
#' - Specifying `width` and `height` in `vegawidget()` is
#' [effective only for single-view charts and layered charts](
#' https://vega.github.io/vega-lite/docs/size.html#limitations).
#' It will not work for contatenated, faceted, or repeated charts.
#'
#' - In the chart specification, the default interpretation of width and height
#' is to describe the dimensions of the
#' **plotting rectangle**, not including the space used by the axes, labels,
#' etc. When `width` and `height` are specified using `vegawidget()`,
#' the meanings change to describe the dimensions of the **entire** rendered chart,
#' including axes, labels, etc.
#'
#' - Keep in mind that the action-links are not a part of the rendered chart,
#' so you may have to account for them yourself. You might expect
#' the height of the action-links to be 15-20 pixels.
#'
#' @inheritParams as_vegaspec
#' @inheritParams autosize
#' @param embed   `vega_embed` object to specify embedding options -
#'   the default is an empty call to [vega_embed()],
#'   which will result in a canvas-rendering and action-links included for
#'   exporting, viewing the Vega-Lite source, and opening the Vega editor.
#' @param ... other arguments passed to [htmlwidgets::createWidget()]
#'
#' @export
#'
vegawidget <- function(spec, embed = NULL, width = NULL, height = NULL, ...) {

  # if `embed` is NULL, check for option
  embed <- embed %||% getOption("vega.embed")

  # if `embed` is still NULL, set using empty call to vega_embed()
  embed <- embed %||% vega_embed()

  # autosize (if needed)
  spec <- autosize(spec, width = width, height = height)

  # use internal methods here because spec has already been validated
  x <-
    .as_json(
      list(
        chart_spec = .as_list(spec),
        embed_options = embed
      )
    )

  vegawidget <-
    htmlwidgets::createWidget(
      "vegawidget",
      x,
      width = width,
      height = height,
      package = "vegawidget",
      ...
    )

  vegawidget
}

#' Shiny output for Vega-Lite
#'
#' @inheritParams htmlwidgets::shinyWidgetOutput
#'
#' @export
#'
vegawidgetOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(
    outputId,
    "vegawidget",
    width,
    height,
    package = "vegawidget"
  )
}

#' Render a shiny output for Vega-Lite
#'
#' @inheritParams htmlwidgets::shinyRenderWidget
#'
#' @export
#'
renderVegawidget <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(
    expr,
    vegawidgetOutput,
    env,
    quoted = TRUE
  )
}
