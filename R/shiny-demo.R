#' Run Shiny demonstration-apps
#'
#' @param example `character`, name of the example to run; if NULL (default),
#'   prints out a list of available examples
#' @param ... additional arguments passed to [shiny::runApp()]
#'
#' @return invisible NULL, called for side-effects
#'
#' @export
#'
vw_shiny_demo <- function(example = NULL, ...) {

  assert_packages("shiny", "fs")

  examples_long <-
    fs::dir_ls(
      system.file("shiny-demo", package = "vegawidget"),
      type = "directory"
    )

  examples <- basename(examples_long)

  if (is.null(example) || !(example %in% examples)) {
    examples_collapse <-
      glue::glue_collapse(glue::double_quote(examples), sep = ", ")
    message(
      glue::glue("Available examples: {examples_collapse}")
    )
    return(invisible(NULL))
  }

  shiny::runApp(
    system.file("shiny-demo", example, package = "vegawidget"),
    ...
  )

  invisible(NULL)
}
