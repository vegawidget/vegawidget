#' Set a signal or data using a reactive expression
#'
#' There are two ways to change a Vega chart using shiny; by setting
#' a signal or by setting a dataset. In either case, you will need to
#' have named your signal or your dataset in the vegaspec.
#'
#' These functions act as observers; use them as you would use
#' [shiny::observe()] or [shiny::observeEvent()].
#'
#' @param expr reactive expression, i.e. `input$slider` or `dataset()`
#' @param output_id `character`, `outputId` for the vegawidget
#' @param name `character`, name of the signal or dataset being set,
#'   as defined in the vegaspec
#' @param use_cache `logical`, for setting data, indicates to
#'   to send Vega only the *changes* in the dataset, rather
#'   than making a hard reset of the dataset
#' @param run `logical` indicates if the chart is to be run immediately
#'
#' @return [shiny::observeEvent()] that responds to changes in `expr`
#' @name shiny-setters
#' @export
#'
vw_shiny_set_signal <- function(expr, output_id, name, run = TRUE) {

  # captures (but does not evaluate) the reactive expression
  expr <- rlang::enquo(expr)

  shiny::observeEvent(
    eventExpr = rlang::eval_tidy(expr),
    handlerExpr = {
      # evaluate the (reactive) expression
      value <- rlang::eval_tidy(expr)
      # call the view API to set the signal value, then (possibly) run
      vw_shiny_message_view(
        output_id,
        fn = "signal",
        params = list(name, value),
        run = run
      )
    }
  )

}

#' @rdname shiny-setters
#' @export
#'
vw_shiny_set_data <- function(expr, output_id, name, use_cache = TRUE,
                              run = TRUE) {

  # if we are caching the data, we need dplyr
  if (use_cache) {
    assert_packages("dplyr")
  }

  # captures (but does not evaluate) the reactive expression
  expr <- rlang::enquo(expr)

  data_old <- data.frame()

  shiny::observeEvent(
    eventExpr = rlang::eval_tidy(expr),
    handlerExpr = {

      # evaluate the (reactive) expression
      data <- rlang::eval_tidy(expr)
      names_data <- names(data)

      # create the change-set only if we are cacheing and the names are the same
      use_changeset <- FALSE
      create_changeset <- use_cache && identical(names_data, names(data_old))
      if (create_changeset) {
        # create change-set
        data_insert <- dplyr::anti_join(data, data_old, by = names_data)
        data_remove <- dplyr::anti_join(data_old, data, by = names_data)

        # use the change-set if it is more-efficient than a reset
        use_changeset <- (nrow(data_insert) + nrow(data_remove) < nrow(data))
      }

      # if we are not using the changeset, make a reset
      if (!use_changeset) {
        data_insert <- data
        data_remove <- NULL
      }

      if (use_cache) {
        # keep a copy of the data in the enclosing environment
        data_old <<- data
      }

      # print(data_insert)
      # print(data_remove)

      # call the view API to invoke the changeset, then (possibly) run
      vw_shiny_message_data(output_id, name, data_insert, data_remove, run)
    }
  )

}

# Likely not exported
# Call the view API from R (shiny)
vw_shiny_message_view <- function(id, fn, params, run) {

  session <- shiny::getDefaultReactiveDomain()

  # prepare a message using the function arguments
  message <- list(id = id, fn = fn, params = params, run = run)

  # send a custom message to JavaScript
  session$sendCustomMessage("callView", message)

  invisible(NULL)
}

#' Dynamically modify data for a vegawidget with shiny
#'
#' @param output_id the div element the widget is bound to
#' @param data_name the named data set in the spec to change
#' @param data_insert a data.frame to pass to the visualization
#' @param data_remove data to be removed
#' @param run indicates to run chart immediately
#'
#' @details Use inside a shiny application with shiny::observe({})
#' @noRd
#'
vw_shiny_message_data <- function(output_id, data_name, data_insert,
                                  data_remove, run) {

  session <- shiny::getDefaultReactiveDomain()

  # prepare a message using the function arguments
  message <- list(
    id = output_id,
    name = data_name,
    data_insert = data_insert,
    data_remove = data_remove,
    run = run
  )

  # send a custom message to JavaScript
  session$sendCustomMessage("changeData", message)

  invisible(NULL)
}


