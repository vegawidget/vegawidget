# some internal functions for working with JS

glue_js <- function(..., .open = "${", .envir = parent.frame()) {
  glue::glue(..., .open = .open, .envir = .envir)
}

# serialize to JS
ser_js <- function(x) {
  jsonlite::toJSON(x, auto_unbox = TRUE)
}


