#' Add vegawidget functions to your package
#'
#' These functions are offered to help you import and re-export vegawidget
#' functions in your package. For more detail, please see
#' [this article](https://vegawidget.github.io/vegawidget/articles/articles/import.html).
#'
#'  `use_vegawidget()`:
#'
#' Adds vegawidget functions:
#'  - [as_vegaspec()], [vw_as_json()]
#'  - `format()`, `print()`, `knit_print()`
#'  - [vegawidget()], [vega_embed()], [vw_set_base_url()]
#'  - [vw_to_svg()] and other image functions
#'  - [vegawidgetOutput()], [renderVegawidget()]
#'
#' In practical terms:
#' - adds **vegawidget** to `Imports` in your package's DESCRIPTION file.
#' - adds **processx**, **rsvg**, **png**, **fs** to `Suggests`
#'   in your package's DESCRIPTION file.
#' - creates `R/utils-vegawidget.R`
#' - you can delete references to functions you do not want
#'   to re-export.
#'
#' If you have your own S3 class for a spec, specify the `s3_class_name`
#' argument. You will have to edit `R/utils-vegawidget-<s3_class_name>.R`:
#' - add the code within your class's method for
#'  to coerce your object to a `vegaspec`.
#'
#' To permit knit-printing of your custom class, you will have to add some code
#' to your package's `.onLoad()` function.
#'
#' **`use_vegawidget_interactive()`**:
#'
#' If you want to add the JavaScript and Shiny functions,
#' use this after running `use_vegawidget()`. It adds:
#'  - [vw_add_data_listener()] and other listener-functions.
#'  - [vw_handler_data()] and other handler functions.
#'  - [vw_shiny_get_data()] and other Shiny getters.
#'  - [vw_shiny_set_data()] and other Shiny setters.
#'
#' In practical terms:
#' - adds **shiny**, **dplyr**, to `Suggests`.
#' - creates `R/utils-vegawidget-interactive.R`.
#' - at your discretion, delete references to functions you do not want
#'   to re-export.
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

    code <-
      usethis::ui_code(
        glue::glue(
          "vegawidget::s3_register(\"knitr::knit_print\", \"{s3_class_name}\")"
        )
      )

    url <- usethis::ui_field('https://vctrs.r-lib.org/reference/s3_register.html')

    usethis::ui_todo(
      "To let knit-printing work, make sure you have this functionality \\
      in {usethis::ui_code('.onLoad()')} \\
      (usually kept in {usethis::ui_value('zzz.R')}):

      {code}

      The function {usethis::ui_value('s3_register()')} \\
      is copied from the vctrs package, see {url}")

  }

  usethis::ui_todo("Document and rebuild package")

  invisible(NULL)
}

#' @rdname use_vegawidget
#' @export
#'
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
