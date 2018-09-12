#' Dynamically modify data for a vegawidget with shiny
#'
#' @param input_id the div element the widget is bound to
#' @param name the named data set in the spec to change
#' @param newdata a data.frame to pass to the visualization
#'
#' @details Use inside a shiny application with shiny::observe({})
#'
#' @name vega-data-handlers
#' @rdname vega-data-handlers
#' @export
vw_change_data <- function(input_id, name, newdata) {
  vw_call_view(input_id, "change",
               list(name = name,
                    data = newdata))
}
