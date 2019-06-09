#' Add vegawidget functions to your package
#'
#' Two functions are offered to
#'
#' To add vegawidget functions to your package, these functions:
#' - adds **vegawidget** to your package's DESCRIPTION file
#' - creates `R/utils-vegawidget.R`
#' - encourages you to take the steps outlined in **Details**
#'
#' You will have to edit `R/utils-vegawidget.R`:
#' - add the code within your class's method for
#'  to coerce your object to a `vegaspec`.
#' - at your discretion, delete references to functions you do not want
#' to re-export.
#'
#' @param s3_class_name `character`, name of an S3 class for object to
#'   be coerced to a `vegaspec`; default (NULL) implies no additional class
#'
#' @return invisible `NULL`, called for side effects
#' @export
#'
use_vegawidget <- function(s3_class_name = NULL) {

  assert_packages("usethis")

  usethis::use_package("vegawidget", type = "Imports")

  suggests <- c("processx", "rsvg", "png", "fs")

  usethis::ui_todo(
    "To render images, {usethis::ui_value('vegawidget')} \\
    uses the packages {usethis::ui_value(suggests)}. \\
    You may wish to add them to this package's \"Suggests\". \\
    As well, your package's users will require \\
    {usethis::ui_value('nodejs')} be installed on their computer."
  )

  # usethis::use_package("httr", type = "Suggests")      # spec
  # usethis::use_package("knitr", type = "Suggests")     # vignettes
  # usethis::use_package("rmarkdown", type = "Suggests")
  # usethis::use_package("processx", type = "Suggests")  # images
  # usethis::use_package("rsvg", type = "Suggests")
  # usethis::use_package("png", type = "Suggests")
  # usethis::use_package("fs", type = "Suggests")

  filename <- glue::glue("R/utils-vegawidget.R")
  usethis::ui_todo(
    "Remove unwanted functions from {usethis::ui_value(filename)}"
  )

  usethis::use_template(
    "utils-vegawidget.R",
    save_as = filename,
    open = TRUE,
    package = "vegawidget"
  )

  # if we have an S3 class
  if (!is.null(s3_class_name)) {
    data <- list(s3_class_name = s3_class_name)

    filename <- glue::glue("R/utils-vegawidget-{s3_class_name}.R")
    usethis::ui_todo(
      "Remove unwanted functions from {usethis::ui_value(filename)}"
    )

    usethis::use_template(
      "utils-vegawidget-class.R",
      save_as = filename,
      data = data,
      open = TRUE,
      package = "vegawidget"
    )

    val_fnname <- usethis::ui_value(glue::glue("as_vegaspec.{s3_class_name}()"))
    usethis::ui_todo("Adapt function {val_fnname}")
  }

  usethis::ui_todo("Document and rebuild package")

  invisible(NULL)
}

use_vegawidget_interactive <- function() {

  # Assumes you already have run use_vegawidget

  assert_packages("usethis")

  usethis::use_package("shiny", type = "Suggests")  # shiny
  usethis::use_package("dplyr", type = "Suggests")

  filename <- glue::glue("R/utils-vegawidget-interactive.R")
  usethis::ui_todo(
    "Remove unwanted functions from {usethis::ui_value(filename)}"
  )

  usethis::use_template(
    "utils-vegawidget-interactive.R",
    save_as = filename,
    open = TRUE,
    package = "vegawidget"
  )

  usethis::ui_todo("Document and rebuild package")

  invisible(NULL)
}
