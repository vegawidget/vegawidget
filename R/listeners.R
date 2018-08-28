

.SHINY_EVENT_HANDLER <-
"
function(event, item) {
  if (item !== null && item !== undefined && item.datum !== undefined){
  Shiny.onInputChange(el.id + '_' + event.type, item.datum);
  } else {
  Shiny.onInputChange(el.id + '_' + event.type,null);
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
