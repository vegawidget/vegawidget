#' JavaScript Handlers
#'
#' A Vega listener needs a handler-function to call when the object
#' being listened-to changes. These functions help you to build
#' such handler-functions in R. The `vw_handler()` function is used
#' by the [shiny-getters] to define the value that is returned
#' through a reactive expression. You can use the `vw_handler_list()`
#' function to discover what predifined handlers are available.
#'
#'
#' @param type `character`, name of the type of handler;
#'   currently-available types are `"signal"` and `"event"`
#' @param body `character`, name of the body of the handler;
#'   currently-available bodies depend on the `type`
#'
#' @return \describe{
#'   \item{`vw_handler()`}{a function that, given a `type`,
#'   returns a JavaScript handler-body}
#'   \item{`vw_handler_list()`}{a list of handlers, organized by `type`
#'   and `body`, prints to a friendly format}
#' }
#'
#' @seealso [vw_shiny_get_signal()], [vw_shiny_get_event()],
#'   vega-view: [addSignalListener()](https://github.com/vega/vega-view#view_addSignalListener),
#'   [addEventListener()](https://github.com/vega/vega-view#view_addEventListener)
#' @examples
#'   \dontrun{
#'     # called from a within a shiny server-function
#'     rct_cyl <- vw_shiny_get_signal(
#'       "chart",
#'       name = "cyl",
#'       handler = vw_handler("value")
#'     )}
#'   vw_handler_list()
#'   vw_handler_list("signal")
#' @export
#'
#'
vw_handler <- function(body) {

  function(type) {

    type_names <- names(.vega_handlers)
    assertthat::assert_that(
      all(type %in% type_names),
      msg = paste(
        "Legal handler types are:",
        paste(type_names, collapse = ", ")
      )
    )

    body_names <- names(.vega_handlers[[type]][["body"]])
    assertthat::assert_that(
      all(body %in% body_names),
      msg = paste(
        "Legal body-names for", type, "handlers are:",
        paste(body_names, collapse = ", ")
      )
    )

    # return the body
    .vega_handlers[[type]][["body"]][[body]]
  }
}

#' @rdname vw_handler
#' @export
#'
vw_handler_list <- function(type = NULL) {

  if (is.null(type)) {
    return(.vega_handlers)
  }

  type_names <- names(.vega_handlers)
  assertthat::assert_that(
    all(type %in% type_names),
    msg = paste(
      "Legal handler types are:",
      paste(type_names, collapse = ", ")
    )
  )

  .vega_handlers[type]
}


# internal data structure to collect JS handlers
.vega_handlers <-
  structure(
    list(
      event = list(
        args = c("event", "item"),
        body = list(
          datum = JS(
            "// return null if nothing there",
            "if (item === null || item === undefined || item.datum === undefined) {",
            "  return null;",
            "}",
            "",
            "return item.datum;"
          )
        )
      ),
      signal = list(
        args = c("name", "value"),
        body = list(
          value = JS(
            "return value;"
          )
        )
      )
    ),
    class = "vw_js_handler"
  )

`[.vw_js_handler` <- function(x, i, ...) {
  structure(
    unclass(x)[i, ...],
    class = "vw_js_handler"
  )
}

#' @noRd
#' @export
print.vw_js_handler <- function(x, ...) {

  print_body <- function(x, name) {
    x_indent <- gsub("\n", "\n  ", x)
    cat("  ", name, ":\n", sep = "")
    cat("  ------\n  ")
    cat(x_indent)
    cat("\n  ------\n\n")
  }

  print_type <- function(x, type) {
    cat("type:", type, "\n")
    cat("args:", paste(x$args, collapse = ", "), "\n")
    cat("body:\n")
    mapply(print_body, x$body, names(x$body))
  }

  mapply(print_type, x, names(x))
}
