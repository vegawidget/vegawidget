#' Mark character strings as literal JavaScript code
#'
#' See \code{htmlwidgets::\link[htmlwidgets]{JS}} for details.
#'
#' @name JS
#' @importFrom htmlwidgets JS
#' @keywords internal
#' @export
#'
NULL

#' @keywords internal
#' @export
#'
print.JS_EVAL <- function(x, ...) {

  cat(x)

  invisible(x)
}

#' Interpolate into a JavaScript string
#'
#' Uses JavaScript notation to interpolate R variables into a string
#' intended to be interpreted as JS.
#'
#' This is a wrapper to [glue::glue()], but it uses the notation used by
#' [JavaScript's template-literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals),
#' `${}`.
#'
#' @inheritParams htmlwidgets::JS
#' @param .open `character`, opening delimiter used by [glue::glue()]
#' @param .envir `environment`, tells [glue::glue()] where to find
#'   the variables to be interpolated
#'
#' @return `glue::glue()` object
#' @examples
#'   x <- 123
#'   glue_js("function(){return(${x});}") %>% print()
#' @export
#'
glue_js <- function(..., .open = "${", .envir = parent.frame()) {
  glue::glue(..., .open = .open, .envir = .envir, .sep = "\n")
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

# helpers to find JavaScript files for v8
widgetlib_file <- function(...) {
  system.file("htmlwidgets", "lib", ..., package = "vegawidget")
}

bin_file <- function(...) {
  system.file("bin", ..., package = "vegawidget")
}
