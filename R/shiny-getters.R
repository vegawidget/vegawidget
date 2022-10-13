#' Get information from a Vega chart into Shiny
#'
#' There are three types of information you can get from a Vega chart,
#' a *signal*, *data* (i.e. a dataset), and information associated with
#' an *event*.  A dataset or a signal must first be defined and **named**
#' in the vegaspec.
#'
#' These getter-functions are called from within
#' a Shiny `server()` function, where they act like
#' [shiny::reactive()], returning a reactive expression.
#'
#' To see these functions in action, you can run a shiny-demo:
#'
#' - `vw_shiny_get_signal()`: call `vw_shiny_demo("signal-set-get")`
#' - `vw_shiny_get_data()`: call `vw_shiny_demo("data-set-get")`
#' - `vw_shiny_get_event()`: call `vw_shiny_demo("event-get")`
#'
#' In addition to the chart `outputId`, you will need to provide:
#'
#' - `vw_shiny_get_signal()`: the `name` of the signal, as defined in the Vega
#'    specification
#' - `vw_shiny_get_data()`: the `name` of the dataset, as defined in the Vega
#'    specification
#' - `vw_shiny_get_event()`: the `event` type, as defined in the
#'    [Vega Event-Stream reference](https://vega.github.io/vega/docs/event-streams/)
#'
#' When the signal or data changes, or when the event fires, Vega needs to
#' know which information you want returned to Shiny. To do this,
#' you provide a JavaScript handler-function:
#'
#' - `vw_shiny_get_signal()`: the default handler,
#'   `vw_handler_signal("value")`,
#'   specifies that the value of the signal be returned.
#'
#' - `vw_shiny_get_data()`: the default handler,
#'   `vw_handler_data("value")`,
#'   specifies that the entire dataset be returned.
#'
#' - `vw_shiny_get_event()`: the default handler,
#'   `vw_handler_event("datum")`,
#'   specifies that the single row of data associated with graphical mark
#'   be returned. For example, if you are monitoring a `"click"` event,
#'   Vega would return the row of data that backs any mark
#'   (like a point) that you click.
#'
#' If you need to specify a different behavior for the handler, there are a
#' couple of options. This package provides
#' a library of handler-functions; call [vw_handler_signal()],
#' [vw_handler_data()], or [vw_handler_event()] without arguments to
#' list the available handlers.
#'
#' If the library does not contain the handler you need, the `body_value`
#' argument will also accept a character string which will be used as
#' the **body** of the handler function.
#'
#' For example, these calls are equivalent:
#'
#' - `vw_shiny_get_signal(..., body_value = "value")`
#' - `vw_shiny_get_signal(..., body_value = vw_handler_signal("value"))`
#' - `vw_shiny_get_signal(..., body_value = "return value;")`
#'
#' If you use a custom-handler that you think may be useful for the
#' handler-function library, please
#' [file an issue](https://github.com/vegawidget/vegawidget/issues).
#'
#' @inheritParams shiny-setters
#' @param name `character`, name of the signal (defined in Vega specification)
#'   being monitored
#' @param body_value `character` or `JS_EVAL`, the **body** of a JavaScript
#'   function that Vega will use to handle the signal or event; this function
#'   must return a value
#'
#' @return [shiny::reactive()] function that returns the value returned by
#'  `body_value`
#' @name shiny-getters
#' @seealso [vw_handler_signal()], [vw_handler_event()],
#'   vega-view:
#'     [addSignalListener()](https://github.com/vega/vega/tree/master/packages/vega-view#view_addSignalListener),
#'     [addEventListener()](https://github.com/vega/vega/tree/master/packages/vega-view#view_addEventListener)
#' @export
#'
vw_shiny_get_signal <- function(outputId, name, body_value = "value") {

  assert_packages("shiny")

  session <- shiny::getDefaultReactiveDomain()

  inputId <- ""

  # set up an observer to run *once* to add the listener
  shiny::observe({

    shiny::isolate({

      # create unique inputId (set in enclosing environment)
      inputId_proposed <- glue::glue("{outputId}_signal_{name}")
      inputId <<- get_unique_inputId(inputId_proposed, names(session$input))

      # compose_handler_body
      handler_body <-
        vw_handler_signal(body_value) %>%
        vw_handler_add_effect("shiny_input", inputId = session$ns(inputId)) %>%
        vw_handler_body_compose(n_indent = 0L)

      # add listener
      vw_shiny_msg_addSignalListener(
        outputId,
        name = name,
        handlerBody = handler_body
      )
    })

  })

  # return a reactive that listens to our "private" input
  shiny::reactive({
    session$input[[inputId]]
  })
}

#' @name shiny-getters
#' @export
#'
vw_shiny_get_data <- function(outputId, name, body_value = "value") {

  assert_packages("shiny")

  session <- shiny::getDefaultReactiveDomain()

  inputId <- ""

  # set up an observer to run *once* to add the listener
  shiny::observe({

    shiny::isolate({

      # create unique inputId (set in enclosing environment)
      inputId_proposed <- glue::glue("{outputId}_data_{name}")
      inputId <<- get_unique_inputId(inputId_proposed, names(session$input))

      # compose_handler_body
      handler_body <-
        vw_handler_data(body_value) %>%
        vw_handler_add_effect("shiny_input", inputId = session$ns(inputId)) %>%
        vw_handler_body_compose(n_indent = 0L)

      # add listener
      vw_shiny_msg_addDataListener(
        outputId,
        name = name,
        handlerBody = handler_body
      )
    })

  })

  # return a reactive that listens to our "private" input
  shiny::reactive({
    x <- session$input[[inputId]]

    # coerce this to a data.frame, if need be
    if (!is.data.frame(x)) {
      x <- data.frame(as.list(x), stringsAsFactors = FALSE)
    }

    x
  })
}

#' @name shiny-getters
#' @param event `character`, type of the event being monitored, e.g. `"click"`,
#'   for list of supported events, please see
#'   [Vega Event-Stream reference](https://vega.github.io/vega/docs/event-streams/)
#' @export
#'
vw_shiny_get_event <- function(outputId, event, body_value = "datum") {

  assert_packages("shiny")

  session <- shiny::getDefaultReactiveDomain()

  inputId <- ""

  # set up an observer to run *once* to add the listener
  shiny::observe({

    shiny::isolate({

      # create unique inputId (set in enclosing environment)
      inputId_proposed <- glue::glue("{outputId}_event_{event}")
      inputId <<- get_unique_inputId(inputId_proposed, names(session$input))

      # compose handler_body
      handler_body <-
        vw_handler_event(body_value) %>%
        vw_handler_add_effect("shiny_input", inputId = session$ns(inputId)) %>%
        vw_handler_body_compose(n_indent = 0L)

      # add listener
      vw_shiny_msg_addEventListener(
        outputId,
        event = event,
        handlerBody = handler_body
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
  input_names <- c(names_input, inputId)

  # make input_names unique
  input_names_new <- make.unique(input_names, sep = "_")

  # return last element, corresponds to `inputId`
  utils::tail(input_names_new, 1)
}
