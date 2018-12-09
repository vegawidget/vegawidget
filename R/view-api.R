# Likely not exported
# Call the view API from R (shiny)
vw_call_view <- function(id, fn, params) {

  session <- shiny::getDefaultReactiveDomain()

  # prepare a message using the function arguments
  message <- list(id = id, fn = fn, params = params)

  # send a custom message to JavaScript
  session$sendCustomMessage("callView", message)

}

#' Create Shiny Observer, Binding Shiny Input to Vega Signal
#'
#' Function to bind a shiny UI element to a Vega signal
#'
#' @param output_id Name of output element
#' @param input_id Name of input element
#' @param signal_name name of signal
#' @param input_transformer optional function to transform input before passing
#' to signal
#'
#' @return shiny observer that will update signal upon changes to input
#' @export
vw_bind_ui <- function(output_id, input_id, signal_name, input_transformer = NULL) {

  input_transformer <- input_transformer %||% identity

  session <- shiny::getDefaultReactiveDomain()

  shiny::observe({
    signal_value <- input_transformer(session$input[[input_id]])
    vw_call_view(output_id, "signal", list(signal_name, signal_value))
  })
}

#' a potentially-useful experiment
#'
#' @param expr reactive expression, i.e. `input$slider` or `dataset()`
#' @param output_id `character` outputId for the vegawidget
#' @param signal_name `character` name of the signal defined in the
#'   vegawidget spec
#'
#' @return [shiny::observeEvent()] that reacts to changes in`expr`
#'
#' @export
vw_observe_to_signal <- function(expr, output_id, signal_name) {

  # captures (but does not evaluate) the reactive expression
  expr <- rlang::enquo(expr)

  shiny::observeEvent(
    eventExpr = rlang::eval_tidy(expr),
    handlerExpr = {
      # evaluate the (reactive) expression
      value <- rlang::eval_tidy(expr)
      # call the view API to set the signal value, then run
      vw_call_view(output_id, fn = "signal", params = list(signal_name, value))
    }
  )

}

vw_observe_to_data <- function(expr, output_id, data_name, use_cache = TRUE) {

  # if we are caching the data, we need dplyr
  if (use_cache) {
    assert_packages("dplyr")
  }

  data_old <- data.frame()

}
