#' Construct a vegawidget handler
#'
#' You will likely call one of the specific handler-constructors:
#' [vw_handler_signal()], [vw_handler_event()], in conjunction with
#' [vw_handler_add_effect()].
#'
#' The handler has three parts:
#'
#' - `args` arguments to the handler
#' - `body_value` the body of a function of the `args`, returns a value
#' - `body_effect` the body of a function of the value, `x`, performs a
#'   side-effect
#'
#' @param args `character`, vector of names for the arguments for the handler
#' @param body_value `character`, body of the *value* part of the handler
#' @param body_effect `character`, body of the *effect* part of the handler
#'
#' @return object with S3 class `vw_handler`
#' @seealso [vw_handler_signal()], [vw_handler_event()],
#'   [vw_handler_add_effect()]
#' @keywords internal
#' @export
#'
vw_handler <- function(args, body_value, body_effect) {
  structure(
    list(
      args = args,
      body_value = body_value,
      body_effect = body_effect
    ),
    class = "vw_handler"
  )
}

print.vw_handler <- function(x, ...) {

  # write out
  cat(compose_list(x$args, "args"), "\n")
  cat("body_value:\n")
  cat(x$body_value %>% glue::glue_collapse(sep = "\n") %>% indent(2L))
  if (!is.null(x$body_effect)) {
    cat("\nbody_effect:\n")
    cat(x$body_effect %>% glue::glue_collapse(sep = "\n") %>% indent(2L))
  }

  invisible(x)
}

#' Constructor for internal S3 class
#'
#' This S3 class is used to define handler-functions.
#'
#' @param args `character`, vector of names of arguments for the
#'   handler-function
#' @param bodies `.vw_handler_body`, list of possible bodies for the
#'   handler-function
#'
#' @return S3 object with class `.vw_handler_def`
#' @keywords internal
#' @seealso .vw_handler_body
#' @export
#'
.vw_handler_def <- function(args, bodies) {
  structure(
    list(args = args, bodies = bodies),
    class = ".vw_handler_def"
  )
}

print..vw_handler_def <- function(x, ...) {

  cat(compose_list(x$args, "arguments"), "\n")

  mapply(
    function(text, name) {
      cat("\n")
      cat(compose_list(name, "  handler_body"), "\n")
      print(text, n_indent = 2)
    },
    x$bodies,
    names(x$bodies)
  )

  invisible(x)
}

#' Constructor for internal S3 class
#'
#' This S3 class is used to define handler-function bodies.
#'
#' @param text `character`, text of the function body
#' @param params `character`, vector of names of required parameters
#'
#' @return S3 object with class `.vw_handler_body`
#' @keywords internal
#' @seealso .vw_handler_def
#' @export
#'
.vw_handler_body <- function(text, params = NULL) {
  structure(
    list(
      text = text,
      params = params
    ),
    class = ".vw_handler_body"
  )
}

print..vw_handler_body <- function(x, n_indent = 0L, ...) {

  # local function to add spaces for indenting
  ind <- function(x) {
    indent(x, n = n_indent)
  }

  # if there are required parameters, print them
  if (!is.null(x$params)) {

    text <-
      x$params %>%
      compose_list("params") %>%
      ind()

    cat(text, "\n")
  }

  # print out the text of the body
  delim <- ind("--------")
  text <- ind(x$text)
  cat(delim, text, delim, sep = "\n")

  invisible(x)
}

compose_list <- function(x, title) {
  x <- glue::glue_collapse(x, sep = ", ")
  x <- glue::glue("{title}: {x}")
}

vw_handler_body <- function(handler_body, type) {

  handler_type <- .vw_handler_library[[type]]

  # if handler_body is a vw_handler, this is a no-op
  if (inherits(handler_body, "vw_handler")) {
    return(handler_body)
  }

  # is this a name of a handler in the library?
  bodies <- handler_type$bodies
  if (handler_body %in% names(bodies)) {
    # use *that* handler_body
    handler_body <- bodies[[handler_body]]$text
  }

  handler_body
}


