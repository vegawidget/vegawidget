#' Get information from a Vega chart
#'
#' There are two types of information you can get from a Vega chart, a signal,
#' and information associated with an event. Using these shiny-getters, you can
#' make this information available as a reactive expression.
#'
#' In addition to the chart `outputId`, you will need to provide:
#'
#' - `vw_shiny_get_signal()`: the `name` of the signal, as defined in the Vega
#'    specification
#' - `vw_shiny_get_event()`: the `event` type, as defined in the
#'    [Vega Event-Stream reference](https://vega.github.io/vega/docs/event-streams/)
#'
#'
#' @inheritParams shiny-setters
#' @param name `character`, name of the signal (defined in Vega specification)
#'   being monitored
#' @param handler `vw_handler()` or `character`, the **body** of a JavaScript
#'   function that Vega will use to handle the signal or event; this function
#'   must return a value
#'
#'
#' @return [shiny::reactive()] that returns the value returned by the
#'  `handler` function
#' @name shiny-getters
#' @seealso [vw_handler()],
#'   vega-view: [addSignalListener()](https://github.com/vega/vega-view#view_addSignalListener)
#' @export
#'
vw_shiny_get_signal <- function(outputId, name, handler = vw_handler("value")) {

  assert_packages("shiny")

  session <- shiny::getDefaultReactiveDomain()

  inputId <- ""

  # get hander_body
  handler_body <- handler
  if (is.function(handler)) {
    handler_body <- handler("signal")
  }

  # set up an observer to run *once* to add the listener
  shiny::observe({

    shiny::isolate({
      # create unique inputId (set in enclosing environment)
      inputId_proposed <- glue::glue("{outputId}_signal_{name}")
      inputId <<- get_unique_inputId(inputId_proposed, names(session$input))

      # add listener
      vw_shiny_msg_addSignalListener(
        outputId,
        name = name,
        handlerBody = handler_body,
        inputId = inputId
      )
    })

  })

  # return a reactive that listens to our "private" input
  shiny::reactive({
    session$input[[inputId]]
  })
}

#' @name shiny-getters
#' @param event `character`, type of the event being monitored, e.g. `"click"`,
#'   for list of supported events, please see
#'   [Vega Event-Stream reference](https://vega.github.io/vega/docs/event-streams/)
#' @export
#'
vw_shiny_get_event <- function(outputId, event, handler = vw_handler("datum")) {

  assert_packages("shiny")

  session <- shiny::getDefaultReactiveDomain()

  inputId <- ""

  # get hander_body
  handler_body <- handler
  if (is.function(handler)) {
    handler_body <- handler("event")
  }

  # set up an observer to run *once* to add the listener
  shiny::observe({

    shiny::isolate({
      # create unique inputId (set in enclosing environment)
      inputId_proposed <- glue::glue("{outputId}_event_{event}")
      inputId <<- get_unique_inputId(inputId_proposed, names(session$input))

      # add listener
      vw_shiny_msg_addEventListener(
        outputId,
        event = event,
        handlerBody = handler_body,
        inputId = inputId
      )
    })

  })

  # return a reactive that listens to our "private" input
  shiny::reactive({
    session$input[[inputId]]
  })
}

get_unique_inputId <- function(inputId, names_input) {

  # compile proposed inputId with names of existing inputs
  input_names <- c(inputId, names_input)

  # make input_names unique
  input_names_new <- make.unique(input_names, sep = "_")

  # return first element, corresponds to `inputId`
  input_names_new[[1]]
}


.SHINY_EVENT_HANDLER <-
"
function(event, item) {
  if (item !== null && item !== undefined && item.datum !== undefined){
    Shiny.onInputChange(el.id + '_' + event.type, item.datum);
  } else {
    Shiny.onInputChange(el.id + '_' + event.type, null);
  }
}
"

.SHINY_SIGNAL_HANDLER <-
"
function(name, value) { Shiny.onInputChange(el.id + '_' + name, value) }
"


#' Event and Signal Listeners
#'
#' @param x a vegawidget object
#' @param event name of an event, e.g. 'click'
#' @param signal name of a signal specified in the vega spec (or created by
#' vega-lite when compiling into vega)
#' @param handler either "shiny" (default) to add a listener that will expose
#' the relevant data to shiny via {output_id}_{event} or {output_id}_{signal}
#' @rdname vega-listeners
#' @name vega-listeners
#' @export
vw_add_event_listener <-  function(x, event, handler = "shiny") {

  # This adds the listener to the widget at render time
  # It may make sense to make this an S3 function
  # If you gave it an ID, you would add the listener
  # after rendering.  Not clear if there are many real-world use cases
  # for that

  # Alternatively, listeners could be provided in the vegawidget function itself...

  if (handler == "shiny") {
    handler <- .SHINY_EVENT_HANDLER
  }

  js_call <- paste0("function(el, x) {this.addEventListener('",
                    event, "', ",handler,")}")
  htmlwidgets::onRender(x, js_call)
}


#' @rdname vega-listeners
#' @export
vw_add_signal_listener <- function(x, signal, handler = "shiny"){
  if (handler == "shiny") {
    handler = .SHINY_SIGNAL_HANDLER
  }

  js_call = paste0("function(el, x) {this.addSignalListener('",
                   signal, "', ",handler,")}")
  htmlwidgets::onRender(x, js_call)
}
