#' Create a Vega/Vega-Lite htmlwidget
#'
#' Renders a chart as an htmlwidget.
#'
#' This function is called `vegawidget()` is because it returns an htmlwidget
#' that uses Vega-Lite and Vega JavaScript libraries, rather than the
#' Altair Python package.
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
#' [vega_embed()] and [only_actions()].
#'
#' If `embed` is `NULL`, `vegawidget()` sets `embed` to the value of
#' `getOption("altair.embed_options")`. Then, if this option is `NULL`, the
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
#' @param spec   chart_specification
#' @param embed   `vega_embed` object to specify embedding options -
#'   the default is an empty call to [vega_embed()],
#'   which will result in a canvas-rendering and action-links included for
#'   exporting, viewing the Vega-Lite source, and opening the Vega editor.
#' @param width   `integer`, if specified, the total rendered width (in pixels)
#'   of the chart - valid only for single-view charts and layered charts;
#'   the default is to use the width in the chart specification
#' @param height  `integer`, if specified, the total rendered height (in pixels)
#'   of the chart - valid only for single-view charts and layered charts;
#'   the default is to use the height in the chart specification
#' @param ... other arguments
#' @seealso [alt], [vega_embed()],
#'   [altair: Field Guide to Rendering Charts](https://vegawidget.github.io/altair/field-guide-rendering.html)
#'
#' \dontrun{
#' }
#' @export
#'
vegawidget <- function(x, embed = NULL, width = NULL, height = NULL, ...) {

  x <-
    list(
      chart_spec = x,
      embed_options = unclass(embed)
    )

  vegawidget <-
    htmlwidgets::createWidget(
      "vegawidget",
      x,
      width = width,
      height = height,
      package = "vegawidget"
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
    package = "altair"
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
