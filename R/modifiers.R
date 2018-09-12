#' Dynamically modify data for a vegawidget with shiny
#'
#' @param input_id the div element the widget is bound to
#' @param name the named data set in the spec to change
#' @param newdata a data.frame to pass to the visualization
#'
#' @details Use inside a shiny application with shiny::observe({})
#'
#' @name vega-data-handlers
#' @rdname vega-data-handlers
#' @export
vw_change_data <- function(input_id, name, newdata) {
  vw_call_view(input_id, "change",
               list(name = name,
                    data = jsonlite::toJSON(newdata,
                                            dataframe = "rows",
                                            pretty = TRUE,
                                            auto_unbox = TRUE)))
}


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

.modifier_js <- function(name, type) {
  paste0(
    "
    function(el, x, data) { this.", type, "('",  name, "', data);}
    "
  )
}

.modifier_r <- function(x, name, newdata, type) {
  stopifnot(
    inherits(newdata, "data.frame"),
    is.character(name) && length(name) == 1L,
    inherits(x, "vegawidget")
  )

  checked_named_dataset(jsonlite::fromJSON(x$x)$chart_spec, name)

  js_call <- .modifier_js(name, type)

  htmlwidgets::onRender(x, js_call, data = newdata)

}


#' Propagate a widget with data
#'
#' @param x a vegawidget object
#' @param name the named data set to import to
#' @param newdata a data.frame to pass to the visualization on render
#'
#' @details If no name field(s) has been specified in the data element
#' of the vega spec as defined by x, this function will throw an error.
#'
#' @name vega-data-loaders
#' @export
vw_load_data <- function(x, name, newdata) {
  .modifier_r(x, name, newdata, "loadData")
}
