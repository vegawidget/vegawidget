
#' Shiny-message functions
#'
#' Use these functions to send messages from Shiny to JavaScript,
#' using the vegawidget JavaScript API.
#'
#' These functions must be called from within a reactive enviromnent. Because
#' their purpose is to cause a side-effect (changing the view of a chart), they
#' should be called from within [shiny::observe()] functions, or equivalent.
#'
#' \describe{
#'   \item{`vw_shiny_msg_callView`}{this is a multipurpose call}
#'   \item{`vw_shiny_msg_changeData`}{}
#'   \item{`vw_shiny_msg_addSignalListener`}{}
#'   \item{`vw_shiny_msg_addEventListener`}{}
#' }
#'
#'
#'
#' @inheritParams shiny-setters
#' @param fn `character`, name of vega-view function to call
#' @param params `list`, list of parameters which which to call `fn`
#' @param run `logical`, indicates if the view should be run immediately,
#'   default is TRUE
#'
#' @return `invisible(NULL)`, called for side-effects
#' @keywords internal
#' @name shiny-message
#' @export
#'
vw_shiny_msg_callView <- function(outputId, fn, params, run) {

  type <- "callView"
  message <- as.list(environment())

  vw_shiny_message(type, message)
}

#' @rdname shiny-message
#' @param name `character` name of the signal or dataset, as defined
#'   in the vegaspec
#' @param data_insert `data.frame`, data to be inserted into
#'  the named dataset
#' @param data_remove `data.frame`, `character`, or `logical`,
#'   data to be removed - if `logical`, `TRUE` indicates to remove
#'   all the previous data, `FALSE` indicates to remove no previous
#'   data - if `character` this will be the body of a JavaScript function
#'   with a single argument, `data.remove`, this will be a predicate
#'   function, returning a boolean.
#'
#' @keywords internal
#' @export
#'
vw_shiny_msg_changeData <- function(outputId, name, data_insert,
                                    data_remove, run) {

  type <- "changeData"
  message <- as.list(environment())

  vw_shiny_message(type, message)
}

#' @rdname shiny-message
#'
#' @param handler `character`, either the name of a handler in the
#'   Vegawidget JavaScript object or a the body of a handler function
#'   for the given listener
#' @param inputId `character`, shiny `inputId` where the value returned by
#'   the handler will be stored
#'
#' @keywords internal
#' @export
#'
vw_shiny_msg_addSignalListener <- function(outputId, name, handler, inputId) {

  type <- "addSignalListener"
  message <- as.list(environment())

  vw_shiny_message(type, message)
}

#' @rdname shiny-message
#'
#' @param event `character`, name of the event to monitor, e.g. `"click"`
#'
#' @keywords internal
#' @export
#'
vw_shiny_msg_addEventListener <- function(outputId, event, handler, inputId) {

  type <- "addEventListener"
  message <- as.list(environment())

  vw_shiny_message(type, message)
}

# internal function to wrap session$sendCustomMessage
vw_shiny_message <- function(type, message) {

  assert_packages("shiny")

  session <- shiny::getDefaultReactiveDomain()

  session$sendCustomMessage(type, message)

  invisible(NULL)
}

