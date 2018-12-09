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
#' @param input a reactive value
#' @param output_id `character` outputId for the vegawidget
#' @param signal_name `character` name of the signal defined in the
#'   vegawidget spec
#' @param input_transformer `function` (optional) applied to the value of `input`
#'   before passing to Vega
#'
#' @return [shiny::observeEvent()] that reacts to changes in `input`
#'
#' @export
vw_observe_signal <- function(input, output_id, signal_name,
                              input_transformer = NULL) {

  # captures (but does not evaluate) the reactive value
  input <- rlang::enquo(input)

  input_transformer <- input_transformer %||% identity

  # experiment for later, to cache data for changesets
  count <- 0

  shiny::observeEvent(
    eventExpr = rlang::eval_tidy(input),
    handlerExpr = {
      signal_value <- input_transformer(rlang::eval_tidy(input))
      vw_call_view(output_id, "signal", list(signal_name, signal_value))
      print(count)
      count <<- count + 1
    }
  )

}
