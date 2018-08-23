checked_named_dataset <- function(x, name) {
  # check we have a named dataset in the data layer
  # can either have a nested list or a flat list here
  if (!is.null(names(x$data))) {
    has_named_datasets <- "name" %in% names(x$data)

    if (!has_named_datasets) {
      stop("No named data found.")
    }

    matches_name <- x$data$name == name
  } else {
    has_named_datasets <-
      vapply(
        x$data,
        function(.) "name" %in% names(.),
        logical(1)
      )
    # all FALSE throw an error
    if (all(!has_named_datasets)) {
      stop("No named data found.")
    }

    matches_name <-
      vapply(
        x$data[has_named_datasets],
        function(.) .[["name"]] == name,
        logical(1)
      )
  }

  if (!any(matches_name)) {
    stop(paste("Data set called", name, "not found in vega spec."))
  }
}

#' Modify data for a vegawidget
#'
#' @param x a vegawidget object
#' @param name the named data set to import to
#' @param newdata a data.frame to pass to the visualization
#'
#' @details If no name field(s) has been specified in the data element
#' of the vega spec as defined by x, this function will throw an error.
#'
#' @name vega-data-handlers
#' @rdname vega-data-handlers
vw_insert_data <- function(x, name, newdata) {

  stopifnot(
    inherits(newdata, "data.frame"),
    is.character(name) && length(name) == 1L
  )

  checked_named_dataset(x, name)

  js_call <- paste0(
    "function(el, x) { this.insert('",  name, "', data).run() }"
    )

  htmlwidgets::onRender(x, js_call, data = newdata)
}

vw_remove_data <- function(x, name, newdata) {

}
