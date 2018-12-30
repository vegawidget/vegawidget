#' Mark character strings as literal JavaScript code
#'
#' See \code{htmlwidgets::\link[htmlwidgets]{JS}} for details.
#'
#' @name JS
#' @export
#' @importFrom htmlwidgets JS
#'
NULL

print.JS_EVAL <- function(x, ...) {

  cat(x)

  invisible(x)
}

#' Interpolate into a JavaScript string
#'
#' Uses (ES6) JavaScript notation to interpolate (R) variables into a string.
#'
#' This is a wrapper to both [htmlwidgets::JS()] and [glue::glue()].
#'
#' @inheritParams htmlwidgets::JS
#' @param .open `character`, opening delimeter used by [glue::glue()]
#' @param .envir `environment`, tells [glue::glue()] where to find
#'   the variables to be interpolated
#'
#' @return `glue::glue()` object
#' @examples
#'   x <- 123
#'   glue_js("function(){return(${x});}")
#' @export
#'
glue_js <- function(..., .open = "${", .envir = parent.frame()) {
  x <- glue::glue(..., .open = .open, .envir = .envir, .sep = "\n")
}

# serialize to JS
ser_js <- function(x) {
  jsonlite::toJSON(x, auto_unbox = TRUE)
}

# indent a text string
indent <- function(x, n = 0L) {

  # generate the spaces
  indent <- paste0(rep(" ", n), collapse = "")

  # insert spaces at beginning of string
  x <- paste0(indent, x)

  # insert spaces after every newline
  x <- gsub("\n", paste0("\n", indent), x)

  # trim at the end if need be

  x
}

