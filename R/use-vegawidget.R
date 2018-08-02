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

  assert_packages("usethis", "whisker", "crayon", "clipr", "desc", "clisymbols")

  data <- list(s3_class_name = s3_class_name)

  usethis::use_template(
    "utils-vegawidget.R",
    save_as = "R/utils-vegawidget.R",
    data = data,
    open = TRUE,
    package = "vegawidget"
  )

  val_fnname <- value(glue::glue("as_vegaspec.{s3_class_name}()"))
  val_filename <- value("R/utils-vegawidget.R")

  todo(glue::glue("Adapt function {val_fnname}"))
  todo(glue::glue("Remove unwanted functions from {val_filename}"))
  todo("Document and rebuild package")

  invisible(NULL)
}
