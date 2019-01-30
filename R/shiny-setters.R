#' Set information in a Vega chart from Shiny
#'
#' There are two ways to change a Vega chart: by setting
#' a *signal* or by setting a *dataset*; you can also
#' direct a Vega chart to re-run itself. Any signal or
#' dataset you set must first be defined and **named** in the vegaspec.
#' These functions are called from within
#' a Shiny `server()` function, where they act like
#' [shiny::observe()] or [shiny::observeEvent()].
#'
#' To see these functions in action, you can run a shiny-demo:
#'
#' - `vw_shiny_set_signal()`: call `vw_shiny_demo("signal-set-get")`
#' - `vw_shiny_set_data()`: call `vw_shiny_demo("data-set")`
#' - `vw_shiny_run()`: call `vw_shiny_demo("data-set-swap-run")`
#'
#' For the signal and data setters, in addition to the chart `outputId`,
#' you will need to provide:
#'
#' - the `name` of the signal or dataset you wish to keep updated
#' - the `value` to which you want to set the signal or dataset;
#'   this should be a reactive expression like `input$slider` or `rct_dataset()`
#' - whether or not you want to `run` the Vega view again immediately
#'   after setting this value
#'
#' If you do not set `run = TRUE` in the setter-function,
#' you can use the `vw_shiny_run()` function to control when
#' the chart re-runs. One possibility is to set its `value` to a reactive
#' expression that refers to, for example, a [shiny::actionButton()].
#'
#' @param outputId `character`, shiny `outputId` for the vegawidget
#' @param name `character`, name of the signal or dataset being set,
#'   as defined in the vegaspec
#' @param value reactive expression, e.g. `input$slider` or `dataset()`,
#'   that returns the value to which to set the signal or dataset
# @param use_cache `logical`, for setting data, indicates to
#   to send Vega only the *changes* in the dataset, rather
#   than making a hard reset of the dataset
#' @param run `logical` indicates if the chart is to be run immediately
#' @param ... other arguments passed on to [shiny::observeEvent()]
#'
#' @return [shiny::observeEvent()] function that responds to changes in the
#'   reactive-expression `value`
#' @name shiny-setters
#' @export
#'
vw_shiny_set_signal <- function(outputId, name, value, run = TRUE, ...) {

  # captures (but does not evaluate) the reactive expression
  value <- rlang::enquo(value)

  shiny::observeEvent(
    eventExpr = rlang::eval_tidy(value),
    handlerExpr = {
      # evaluate the (reactive) expression
      value <- rlang::eval_tidy(value)
      # call the view API to set the signal value, then (possibly) run
      vw_shiny_msg_callView(
        outputId,
        fn = "signal",
        params = list(name, value),
        run = run
      )
    },
    ...
  )

}

#' @rdname shiny-setters
#' @export
#'
vw_shiny_set_data <- function(outputId, name, value, run = TRUE, ...) {

  # until we sort things out with Vega, cacheing will not work
  use_cache <- FALSE

  # if we are caching the data, we need dplyr
  if (use_cache) {
    assert_packages("dplyr")
  }

  # captures (but does not evaluate) the reactive expression
  value <- rlang::enquo(value)

  data_old <- data.frame()

  shiny::observeEvent(
    eventExpr = rlang::eval_tidy(value),
    handlerExpr = {

      # evaluate the (reactive) expression
      data <- rlang::eval_tidy(value)
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
      vw_shiny_msg_changeData(outputId, name, data_insert, data_remove, run)
    },
    ...
  )

}

#' @rdname shiny-setters
#' @export
#'
vw_shiny_run <- function(outputId, value, ...) {

  # captures (but does not evaluate) the reactive expression
  value <- rlang::enquo(value)

  shiny::observeEvent(
    eventExpr = rlang::eval_tidy(value),
    handlerExpr = {
      # call the view API to run
      vw_shiny_msg_run(outputId)
    },
    ...
  )
}


