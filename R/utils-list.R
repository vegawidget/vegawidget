#' Pluck and combine recursively
#'
#' Given a list, `.x`, and a set of accessors, `...`, return a list
#' of objects within `.x` that satisfy the list of accessors.
#'
#'
#' @inheritParams purrr::pluck
#' @param .predicate `function` that takes a single argument, returns
#'   a logical value indicating if this is the "thing" you are
#'   looking for.
#' @param .combine `function` that takes a single argument, a list of
#'   "things" you are looking for, returns a (potentially shorter) list
#'   of "things" that should be kept. You can use this argument to
#'   provide a function to filter out duplicates.
#'
#' @return `list()`
#'
#'
pluck_all <- function(.x, ..., .predicate = NULL, .combine = NULL) {

  # default functions:
  #  - predicate always returns true
  #  - combine is `identity()`
  .predicate <- .predicate %||% function(x) TRUE
  .combine <- .combine  %||% function(x) purrr::discard(x, is.null)

  # search this item using accessors
  result_here <- purrr::pluck(.x, ...)

  # if something found *here* does not satisfy the predicate, set to NULL
  if (!identical(.predicate(result_here), TRUE)) {
    result_here <- NULL
  }

  # iterate over elements
  result_children <- NULL
  if (rlang::is_list(.x) || rlang::is_environment(.x)) {
    result_children <-
      purrr::map(
        .x,
        pluck_all,
        ...,
        .predicate = .predicate,
        .combine = .combine
      )

    result_children <- purrr::flatten(result_children)
  }

  # combine
  if (is.null(result_here)) {
    result_all <- result_children
  } else {
    result_all <- c(list(result_here), unname(result_children))
  }

  # remove duplicates
  result_all <- .combine(result_all)

  result_all
}

combine_signals <- function(.x) {

  # remove nulls
  .x <- purrr::discard(.x, is.null)

  # get names
  signal_names <- purrr::map_chr(.x, purrr::pluck, "name")

  # determine which names are duplicates
  is_duplicate <- duplicated(signal_names)

  message(
    glue::glue(
      "Removing duplicated signal-names: ",
      "{glue::glue_collapse(signal_names[is_duplicate], sep = ', ')}"
    )
  )

  # return the non-duplicates
  .x[!is_duplicate & !is_null]
}

is_signal <- function(x) {

  is_signal <-
    rlang::is_list(x) &&
    identical(names(x), c("name", "value")) &&
    rlang::is_scalar_character(x[["name"]])

  is_signal
}

