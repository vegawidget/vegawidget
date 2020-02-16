#' Pluck and combine recursively
#'
#'
#' @inheritParams purrr::pluck
#' @param .predicate `function` that takes a single argument, returns
#'   a logical value indicating if this is the "thing" you are
#'   looking for.
#' @param .equivalence `function` that takes two arguments, returns a
#'   logical value indicating if these these things are equivalent.
#'
#' @return `list()`
#'
#'
pluck_all <- function(.x, ..., .predicate = NULL, .equivalence = NULL) {

  # default functions:
  #  - predicate always returns true
  #  - equality is `identity()`
  .predicate <- .predicate %||% function(x) TRUE
  .equivalence <- .equivalence  %||% identical

  # maybe issue a message if removing a duplicate

  # how do we define a duplicate?

}

#' Combine lists
#'
#' @param .x `list()` to be combined
#' @param .y `list()` to be combined
#'
#'
#' @return `list()`
#'
combine_lists <- function(.x, .y) {

}

is_signal <- function(x) {

  is_signal <-
    rlang::is_list(x) &&
    identical(names(x), c("name", "value")) &&
    rlang::is_scalar_character(x[["name"]])

  is_signal
}

equivalence_signal <- function(x, y) {
  identical(x[["name"]], y[["name"]])
}
