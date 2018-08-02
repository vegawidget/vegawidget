# This is a collection of functions from usethis that are not exported.
#
# Putting them here is a temporary solution while the tidyverse folks
# work on where and how they might be exported.
#
# It is presumed that these functions are written by Hadley Wickham.
#

## R/style.R

bullet <- function(lines, bullet) {
  lines <- paste0(bullet, " ", lines)
  cat_line(lines)
}

todo_bullet <- function() crayon::red(clisymbols::symbol$bullet)

todo <- function(...) {
  bullet(paste0(...), bullet = todo_bullet())
}
done <- function(...) {
  bullet(paste0(...), bullet = crayon::green(clisymbols::symbol$tick))
}

code_block <- function(..., copy = interactive()) {
  block <- paste0("  ", c(...), collapse = "\n")
  if (copy && clipr::clipr_available()) {
    clipr::write_clip(paste0(c(...), collapse = "\n"))
    message("Copying code to clipboard:")
  }
  cat_line(crayon::make_style("darkgrey")(block))
}

cat_line <- function(...) {
  cat(..., "\n", sep = "")
}

field <- function(...) {
  x <- paste0(...)
  crayon::green(x)
}
value <- function(...) {
  x <- paste0(...)
  crayon::blue(encodeString(x, quote = "'"))
}

code <- function(...) {
  x <- paste0(...)
  crayon::make_style("darkgrey")(encodeString(x, quote = "`"))
}

## R/helpers.R

project_name <- function(base_path = usethis::proj_get()) {
  desc_path <- file.path(base_path, "DESCRIPTION")

  if (file.exists(desc_path)) {
    desc::desc_get("Package", base_path)[[1]]
  } else {
    basename(normalizePath(base_path, mustWork = FALSE))
  }
}

use_description_field <- function(name,
                                  value,
                                  base_path = usethis::proj_get(),
                                  overwrite = FALSE) {
  curr <- desc::desc_get(name, file = base_path)[[1]]
  if (identical(curr, value)) {
    return(invisible())
  }

  if (!is.na(curr) && !overwrite) {
    stop(
      field(name), " has a different value in DESCRIPTION. ",
      "Use overwrite = TRUE to overwrite.",
      call. = FALSE
    )
  }

  done("Setting ", field(name), " field in DESCRIPTION to ", value(value))
  desc::desc_set(name, value, file = base_path)
  invisible()
}

## returns TRUE if user selects answer corresponding to `true_for`
## returns FALSE if user selects other answer or enters 0
## errors in non-interactive() session
## it is caller's responsibility to avoid that
ask_user <- function(...,
                     true_for = c("yes", "no")) {
  true_for <- match.arg(true_for)
  yes <- true_for == "yes"

  message <- paste0(..., collapse = "")
  if (!interactive()) {
    stop(
      "User input required in non-interactive session.\n",
      "Query: ", message, call. = FALSE
    )
  }

  yeses <- c("Yes", "Definitely", "For sure", "Yup", "Yeah", "I agree", "Absolutely")
  nos <- c("No way", "Not now", "Negative", "No", "Nope", "Hell no")

  qs <- c(sample(yeses, 1), sample(nos, 2))
  rand <- sample(length(qs))
  ret <- if(yes) rand == 1 else rand != 1

  cat(message)
  ret[utils::menu(qs[rand])]
}
