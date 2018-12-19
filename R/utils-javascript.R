#' Mark character strings as literal JavaScript code
#'
#' See \code{htmlwidgets::\link[JS]{JS}} for details.
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
#' @return [htmlwidgets::JS()] object, type of charatcter vector
#' @examples
#'   x <- 123
#'   glue_js("function(){return(${x});}")
#' @export
#'
glue_js <- function(..., .open = "${", .envir = parent.frame()) {
  glue::glue(JS(...), .open = .open, .envir = .envir)
}

# serialize to JS
ser_js <- function(x) {
  jsonlite::toJSON(x, auto_unbox = TRUE)
}


