#' Add JavaScript listeners
#'
#' Listeners are how we get information out of a Vega chart and into the
#' JavaScript environment. To do this, we specify handler-functions to
#' run whenever a certain signal changes or an event fires.
#'
#' The `handler_body` can be the text of the *body* of a JavaScript function;
#' the arguments to this function will vary according to the type of listener
#' you are adding:
#'
#' - signal-handler and data-handler arguments: `name`, `value`
#' - event-handler arguments: `event`, `item`
#'
#' This package offers some functions to make it easier to build JavaScript
#' handler functions from R: [vw_handler_signal()], [vw_handler_data()],
#' and [vw_handler_event()]. You can pipe one of these functions to
#' [vw_handler_add_effect()] to perform side-effects on the result.
#'
#' @name add-listeners
#'
#' @param x vegawidget object to be monitored
#' @param name `character`, name of the signal or dataset to be monitored
#' @param handler_body `character` or `JS_EVAL`, text of the body of
#'  the JavaScript handler-function to be called when the signal or dataset
#'  changes, or the event fires
#'
#' @return modified copy of vegawidget object `x`
#' @seealso [vw_handler_signal()], [vw_handler_data()], [vw_handler_event()],
#'   [vw_handler_add_effect()]
#'   vega-view:
#'     [addSignalListener()](https://vega.github.io/vega/docs/api/view#view_addSignalListener),
#'     [addDataListener()](https://vega.github.io/vega/docs/api/view/#view_addDataListener),
#'     [addEventListener()](https://vega.github.io/vega/docs/api/view#view_addEventListener)
#' @export
#'
vw_add_signal_listener <- function(x, name, handler_body) {

  # make this into a vw_handler, compose
  handler_body <-
    handler_body %>%
    vw_handler_signal() %>%
    vw_handler_body_compose(n_indent = 6L)

  js_call <-
    glue_js(
      "function(el, x) {",
      "  this.viewPromise.then(function(view) {",
      "    view.addSignalListener('${name}', function(name, value) {",
      "${handler_body}",
      "    });",
      "  });",
      "}"
    )

  htmlwidgets::onRender(x, js_call)
}

#' @rdname add-listeners
#' @export
#'
vw_add_data_listener <- function(x, name, handler_body) {

  # make this into a vw_handler, compose
  handler_body <-
    handler_body %>%
    vw_handler_signal() %>%
    vw_handler_body_compose(n_indent = 6L)

  js_call <-
    glue_js(
      "function(el, x) {",
      "  this.viewPromise.then(function(view) {",
      "    view.addDataListener('${name}', function(name, value) {",
      "${handler_body}",
      "    });",
      "  });",
      "}"
    )

  htmlwidgets::onRender(x, js_call)
}

#' @rdname add-listeners
#'
#' @param event `character`, name of the type of event to be monitored,
#'   e.g. `"click"`
#'
#' @export
#'
vw_add_event_listener <- function(x, event, handler_body) {

  # make this into a vw_handler, compose
  handler_body <-
    handler_body %>%
    vw_handler_event() %>%
    vw_handler_body_compose(n_indent = 6L)

  js_call <-
    glue_js(
      "function(el, x) {",
      "  this.viewPromise.then(function(view) {",
      "    view.addEventListener('${event}', function(event, item) {",
      "${handler_body}",
      "    });",
      "  });",
      "}"
    )

  htmlwidgets::onRender(x, js_call)
}

