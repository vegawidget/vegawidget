#' Add vegawidget functions to your package
#'
#' This function does the setup for your package to use vegawidget functions:
#' - adds **vegawidget** to "Imports" in your package's DESCRIPTION file
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
#'   be coerced to a `vegaspec`
#'
#' @return invisible `NULL`, called for side effects
#' @export
#'
use_vegawidget <- function(s3_class_name) {

  assert_packages("usethis")

  data <- list(s3_class_name = s3_class_name)

  usethis::use_template(
    "utils-vegawidget.R",
    save_as = "R/utils-vegawidget.R",
    data = data,
    open = TRUE,
    package = "vegawidget"
  )

  val_fnname <- usethis::ui_value(glue::glue("as_vegaspec.{s3_class_name}()"))
  val_filename <- usethis::ui_value("R/utils-vegawidget.R")

  usethis::ui_todo("Adapt function {val_fnname}")
  usethis::ui_todo("Remove unwanted functions from {val_filename}")
  usethis::ui_todo("Document and rebuild package")

  invisible(NULL)
}
