#' Construct a JavaScript handler
#'
#' A Vega listener needs a JavaScript handler-function to call
#' when the object-being-listened-to changes. For instance, [shiny-getters] and
#' [add-listeners] functions each have an argument called
#' `body_value`, which these functions help you build.
#'
#' There are two types of handlers defined in this package's handler-library.
#' To see the handlers that are defined for each, call the function
#' without any arguments:
#'
#' - `vw_handler_signal()`
#' - `vw_handler_data()`
#' - `vw_handler_event()`
#'
#' With a JavaScript handler, you are trying to do two types of things:
#'
#' - calculate a value based on the handler's arguments
#' - produce a side-effect based on that calculated value
#'
#' Let's look at a concrete example.
#' A [*signal* handler](https://vega.github.io/vega/docs/api/view#view_addSignalListener)
#' will take arguments `name` and `value`. Let's say that we want to
#' return the value. We could do this two ways:
#'
#' - `vw_handler_signal("value")`: use this package's handler library
#' - `vw_handler_signal("return value;")`: supply the body of the
#'   handler-function yourself
#'
#' In the list above, the two calls do exactly the same thing, they build a
#' JavaScript function that returns the `value` provided by whatever is calling
#' the signal-handler. This will be a valid signal-handler, however, we will
#' likely want a signal-handler to *do* something with that value, which is
#' why we may wish to add a side-effect.
#'
#' Let's say we want the handler to print the value to the JavaScript console.
#' We would create the signal-handler, then add an effect to print the result
#' to the console.
#'
#' `vw_handler_signal("value") %>% vw_handler_add_effect("console")`
#'
#' We can add as many effects as we like; for more information,
#' please see the documentation for [vw_handler_add_effect()].
#'
#' Please be aware that these functions do *not* check for the correctness
#' of JavaScript code you supply - any errors you make will not be apparent
#' until your visualization is rendered in a browser.
#'
#' One last note, if `body_value` is already a `vw_handler`, these functions
#' are no-ops; they will return the `body_value` unchanged.
#'
#' @param body_value `character`, the name of a defined handler-body,
#'   or the text of the body of a handler-function
#'
#' @return object with S3 class `vw_handler`
#' @seealso [vw_handler_add_effect()]
#'   vega-view:
#'     [addSignalListener()](https://vega.github.io/vega/docs/api/view#view_addSignalListener),
#'     [addDataListener()](https://vega.github.io/vega/docs/api/view#view_addDataListener),
#'     [addEventListener()](https://vega.github.io/vega/docs/api/view#view_addEventListener)
#' @examples
#'   # list all the available signal-handlers
#'   vw_handler_signal()
#'
#'   # list all the available data-handlers
#'   vw_handler_data()
#'
#'   # list all the available event-handlers
#'   vw_handler_event()
#'
#'   # use a defined signal-handler
#'   vw_handler_signal("value")
#'
#'   # define your own signal-handler
#'   vw_handler_signal("return value;")
#' @export
#'
vw_handler_signal <- function(body_value) {

  handler_type <- .vw_handler_library[["signal"]]

  # if handler_body is missing, print out available handlers
  if (missing(body_value)) {
    print(handler_type)
    return(invisible(NULL))
  }

  # if handler_body is a handler, return the handler
  if (inherits(body_value, "vw_handler")) {
    return(body_value)
  }

  # get the handler_body
  body_value <- vw_handler_body(body_value, "signal")

  # create the handler
  args <- handler_type$args
  vw_handler(args, body_value, NULL)
}

#' @rdname vw_handler_signal
#' @export
#'
vw_handler_data <- function(body_value) {

  handler_type <- .vw_handler_library[["data"]]

  # if handler_body is missing, print out available handlers
  if (missing(body_value)) {
    print(handler_type)
    return(invisible(NULL))
  }

  # if handler_body is a handler, return the handler
  if (inherits(body_value, "vw_handler")) {
    return(body_value)
  }

  # get the handler_body
  body_value <- vw_handler_body(body_value, "signal")

  # create the handler
  args <- handler_type$args
  vw_handler(args, body_value, NULL)
}

#' @rdname vw_handler_signal
#' @export
#'
vw_handler_event <- function(body_value) {

  handler_type <- .vw_handler_library[["event"]]

  # if handler_body is missing, print out available handlers
  if (missing(body_value)) {
    print(handler_type)
    return(invisible(NULL))
  }

  # if handler_body is a handler, return the handler
  if (inherits(body_value, "vw_handler")) {
    return(body_value)
  }

  # get the handler_body
  body_value <- vw_handler_body(body_value, "event")

  # create the handler
  args <- handler_type$args
  vw_handler(args, body_value, NULL)
}

#' Add a side-effect to a JavaScript handler
#'
#' With a JavaScript handler, once you have calculated a value
#' based on the handler's arguments (e.g. `name`, `value`) you will
#' likely want to produce a side-effect based on that calculated value.
#' This function helps you do that.
#'
#' The calculation of a value is meant to be separate from the
#' production of a side-effect. This way, the code for a side-effect
#' can be used for any type of handler.
#'
#' You are supplying the `body_effect` to an effect-handler. This
#' takes a single argument, `x`, representing the
#' calculated value. Doing this allows us to chain side-effects together;
#' be careful not to modify `x` in any of the code you provide.
#'
#' To see what side-effects are available in this package's handler-library,
#' call `vw_handler_add_effect()` without any arguments. You may notice that
#' some of the effects, like `"element_text"`, require additional parameters,
#' in this case, `selector`.
#'
#' Those parameters with a default value of `NULL` require you to supply
#' a value; those with sensible defaults are optional.
#'
#' To provide the parameters, call
#' `vw_handler_add_effect()` with *named* arguments corresponding to the
#' names of the parameters. See the examples for details.
#'
#' @param vw_handler `vw_handler` created using [vw_handler_signal()] or
#'   [vw_handler_event()]
#' @param body_effect `character`, the name of a defined handler-body,
#'   or the text of the body of a handler-function
#' @param ... additional *named* parameters to be interpolated into the
#'   text of the handler_body
#'
#' @return modified copy of `vw_handler`
#' @seealso [vw_handler_signal()]
#' @examples
#'   # list all the available effect-handlers
#'   vw_handler_add_effect()
#'
#'   # build a signal handler that prints some text,
#'   # then the value, to the console
#'   vw_handler_signal("value") %>%
#'     vw_handler_add_effect("console", label = "signal value:")
#'
#' @export
#'
vw_handler_add_effect <- function(vw_handler, body_effect, ...) {

  handler_type <- .vw_handler_library[["effect"]]

  # if vw_handler is missing, print out available handlers
  if (missing(vw_handler)) {
    print(handler_type)
    return(invisible(NULL))
  }

  # get the handler_body
  body_effect <- vw_handler_body(body_effect, "effect")

  # handler body needs to return text and a list of parameters

  # blend the parameters
  params_new <- list(...)
  params_default <- body_effect$params

  names_common <-
    names(params_new)[names(params_new) %in% names(params_default)]

  params <- params_default
  params[names_common] <- params_new[names_common]

  # if any of the params are null, warn
  index_null <- vapply(params, is.null, logical(1L))
  names_null <- names(params[index_null])

  if (length(names_null) > 0L) {
    warning(
      "params not set: ",
      glue::glue_collapse(names_null, sep = ", ")
    )
  }

  # mix in the parameters
  handler_text <-
    do.call(glue_js, c(as.list(body_effect$text), list(.envir = params)))

  # append the new effect
  vw_handler$body_effect <- c(vw_handler$body_effect, handler_text)

  vw_handler
}

#' Compose a JavaScript handler
#'
#' These functions are used to compose a `vw_handler` object into
#' text that will be interpreted either as a complete JavaScript
#' function, or a function-body.
#'
#' @inheritParams vw_handler_add_effect
#' @param n_indent `integer`, number of spaces to indent the text of the body
#'
#' @return object with S3 class `JS_EVAL`, text for the function or
#'   function-body
#'
#' @keywords internal
#' @export
#'
vw_handler_body_compose <- function(vw_handler, n_indent = 2L) {

  body_value <-
    glue::glue_collapse(vw_handler$body_value$text, sep = "\n")

  # does the handler-body have no effects?
  if (is.null(vw_handler$body_effect)) {
    # no effects, only value
    body <- body_value
  } else {
    # we do have effects, combine with value
    body_value <- indent(body_value, 4L)

    body_effect <-
      glue::glue_collapse(vw_handler$body_effect, sep = "\n") %>%
      indent(2L)

    body <-
      glue_js(
        "(function (x) {",
        "${body_effect}",
        "})(",
        "  (function () {",
        "${body_value}",
        "  })()",
        ")"
      )
  }

  body <-
    body %>%
    indent(n_indent) %>%
    JS()

  body
}

#' @rdname vw_handler_body_compose
#' @keywords internal
#' @export
#'
vw_handler_compose <- function(vw_handler) {

  args <- glue::glue_collapse(vw_handler$args, sep = ", ")
  body <- vw_handler_body_compose(vw_handler, n_indent = 2L)

  fn <- glue_js(
    "function (${args}) {",
    "${body}",
    "}"
  )

  JS(fn)
}
