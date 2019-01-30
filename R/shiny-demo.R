#' Run Shiny demonstration-apps
#'
#' @param example `character`, name of the example to run; if NULL (default),
#'   prints out a list of available examples
#' @param ... additional arguments passed to [shiny::runApp()]
#'
#' @return invisible NULL, called for side-effects
#' @examples
#'   vw_shiny_demo() # returns available examples
#'
#'   # Run only in interactive R sessions
#'   if (interactive()) {
#'     vw_shiny_demo("data-set")
#'   }
#' @export
#'
vw_shiny_demo <- function(example = NULL, ...) {

  assert_packages("shiny", "fs")

  # get the entire path
  examples_long <-
    fs::dir_ls(
      system.file("shiny-demo", package = "vegawidget"),
      type = "directory"
    )

  # trim so it's just the directory-names
  examples <- basename(examples_long)

  # if a "good" example is not provided, message the available examples
  if (is.null(example) || !(example %in% examples)) {
    examples_collapse <-
      glue::glue_collapse(glue::double_quote(examples), sep = ", ")
    message(
      glue::glue("Available examples: {examples_collapse}")
    )
    return(invisible(NULL))
  }

  # run the app
  shiny::runApp(
    system.file("shiny-demo", example, package = "vegawidget"),
    ...
  )

  invisible(NULL)
}
