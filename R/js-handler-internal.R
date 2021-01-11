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

#' @keywords internal
#' @export
#'
print.vw_handler <- function(x, ...) {

  # write out
  cat(compose_list(x$args, "arguments"), "\n")
  cat("\n")
  cat("body_value:\n")
  cat(x$body_value$text %>% glue::glue_collapse(sep = "\n") %>% indent(2L))
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

  if (identical(x$args, "x")) {
    body_name <- "  body_effect"
  } else {
    body_name <- "  body_value"
  }

  mapply(
    function(text, name) {
      cat("\n")
      cat(compose_list(name, body_name), "\n")
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

print_list <- function(x) {
  # make a list print like the code that created it
  x <- jsonlite::toJSON(x, auto_unbox = TRUE, null = "null")
  x <- gsub(",", ", ", x) # put space after comma
  x <- gsub("\\{(.*)\\}", "\\1", x) # remove {}
  x <- gsub("\"([^\"]+)\":", "\\1 = ", x) # remove quotes
  x <- gsub("null", "NULL", x) # capitalize NULL

  x
}

print..vw_handler_body <- function(x, n_indent = 0L, ...) {

  # if there are parameters, print them
  if (length(x$params) > 0L) {

    text <-
      x$params %>%
      print_list() %>%
      compose_list("params") %>%
      indent(n_indent + 2L)

    cat(text, "\n")
  }

  # print out the text of the body
  text <- indent(x$text, n = n_indent + 2L)
  cat("\n")
  cat(text, sep = "\n")

  invisible(x)
}

compose_list <- function(x, title) {
  x <- glue::glue_collapse(x, sep = ", ")
  x <- glue::glue("{title}: {x}")
}

vw_handler_body <- function(handler_body, type) {

  text <- handler_body
  params <- list()

  # is this a name of a handler in the library?
  bodies <- .vw_handler_library[[type]][["bodies"]]
  if (handler_body %in% names(bodies)) {
    # use *that* handler_body
    text <- bodies[[handler_body]]$text
    params <- bodies[[handler_body]]$params
  }

  # collapse into a single string
  text <- glue::glue_collapse(text, sep = "\n")

  # if this is has no whitespace, parentheses, or semicolons, issue a warning
  js_pattern <- "(\\s|\\(|\\)|;)"
  if (!grepl(js_pattern, text)) {
    warning(
      "handler_body: '",
      text,
      "' does not appear to contain valid JavaScript code, ",
      "and it is not a known ", type, " handler."
    )
  }

  list(text = text, params = params)
}


