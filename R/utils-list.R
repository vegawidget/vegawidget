#' Pluck and combine recursively
#'
#' Given a list, `.x`, and a set of accessors, `...`, return a list
#' of objects within `.x` that satisfy the list of accessors
#'
#'
#' @inheritParams purrr::pluck
#' @param .predicate `function` that takes a single argument, returns
#'   a logical value indicating if this is the "thing" you are
#'   looking for.
#' @param .combine `function` that takes a single argument, a list of
#'   "things" you are looking for, returns a (potentially shorter) list
#'   of "things" that should be kept. Use this function to filter out
#'   duplicates.
#'
#' @return `list()`
#'
#'
pluck_all <- function(.x, ..., .predicate = NULL, .combine = NULL) {

  # default functions:
  #  - predicate always returns true
  #  - combine is `identity()`
  .predicate <- .predicate %||% function(x) TRUE
  .combine <- .combine  %||% identity

  # maybe issue a message if removing a duplicate

  # how do we define a duplicate?

}

#' Combine lists
#'
#' @param .x `list()` to be combined
#'
#'
#' @return `list()`
#'
combine_signals <- function(.x) {

  # get names
  signal_names <- purrr::map_chr(.x, purrr::pluck, "name")

  # determine which names are duplicates
  is_duplicate <- duplicated(signal_names)

  # return the non-duplicates
  .x[!is_duplicate]
}

is_signal <- function(x) {

  is_signal <-
    rlang::is_list(x) &&
    identical(names(x), c("name", "value")) &&
    rlang::is_scalar_character(x[["name"]])

  is_signal
}

