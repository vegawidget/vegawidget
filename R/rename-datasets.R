#' Rename datasets in a vegaspec
#'
#' If a vegaspec has named datasets, it may be useful to rename them.
#' This function will return a vegaspec with datasets named `data_001`,
#' `data_002`, and so on. It will go through the spec and replace the
#' references to the names. A future version of this function may give you
#' the more control over the names used.
#'
#' @inheritParams as_vegaspec
#'
#' @return S3 object of class `vegaspec`
#' @export
#'
vw_rename_datasets <- function(spec) {

  # coerce to vegaspec
  spec <- as_vegaspec(spec)

  # if datasets not present, return spec
  if (!("datasets" %in% names(spec))) {
    return(spec)
  }

  # determine dataset names
  dataset_names <- names(spec$datasets)

  # create new dataset names
  dataset_names_new <- list(sprintf("data_%03d", seq_along(dataset_names)))
  names(dataset_names_new) <- dataset_names

  # create function to replace names
  fn_replace <- function(x) {

    if (rlang::has_name(dataset_names_new, x)) {
      x <- dataset_names_new[[x]]
    }

    x
  }

  # replace dataset names
  names(spec$datasets) <- dataset_names_new

  # function to crawl recursively through the spec
  fn_crawl <- function(x, fn_rep) {

    # x is data.frame OR x is not list, return x
    if (is.data.frame(x) || !is.list(x)) {
      return(x)
    }

    # if x has element "data", data has element "name"
    if (rlang::has_name(x, "data") && rlang::has_name(x$data, "name")) {
      # replace name
      x$data$name <- fn_rep(x$data$name)
    }

    # call for each element of list
    x <- lapply(x, fn_crawl, fn_rep)

    x
  }

  spec <- fn_crawl(spec, fn_replace)
  spec <- as_vegaspec(spec)

  spec
}
