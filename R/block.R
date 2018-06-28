#' Create a yaml string for a block
#'
#'
#' @param license   `character` specifies the license
#' @param height    `numeric` height of the block (pixels)
#' @param scrolling `logical` indicates to use scrolling bars
#' @param border    `logical` indicates to put a border on the `iframe`
#'
#' @return `character` yaml string for `.block` file
#'
#' @seealso [Blocks documentation](https://bl.ocks.org/-/about)
#'
block_yaml <- function(license = "mit", height = 500, scrolling = TRUE, border = TRUE){

  assert_packages("yaml")

  # ref:  https://bl.ocks.org/licenses.txt
  license_legal <- c(
    "apache-2.0",
    "bsd-2-clause",
    "bsd-3-clause",
    "cc-by-4.0",
    "cc-by-nc-4.0",
    "cc-by-nc-nd-4.0",
    "cc-by-nc-sa-4.0",
    "cc-by-nd-4.0",
    "cc-by-sa-4.0",
    "cddl-1.0",
    "epl-1.0",
    "gpl-2.0",
    "gpl-3.0",
    "lgpl-2.1",
    "lgpl-3.0",
    "mit",
    "mpl-2.0",
    "none"
  )

  assertthat::assert_that(
    license %in% license_legal,
    msg = paste("license not legal, see documentation (?block_yaml) for details")
  )

  config <-
    list(
      license = license,
      height = as.integer(height),
      scrolling = as.logical(scrolling),
      border = as.logical(border)
    )

  yaml::as.yaml(config)
}

#'
#'
#'
create_block <- function(spec, embed = vega_embed(), description = NULL,
                         block = block_yaml(), readme = NULL,
                         use_thumbnail = TRUE, use_preview = TRUE,
                         git_method = c("ssh", "https") ) {

  assert_packages(c("gistr", "fs"))

  git_method <- match.arg(git_method)

  dir_temp <- tempdir()

  manifest <- list(
    block = fs::path(dir_temp, ".block"),
    index = fs::path(dir_temp, "index.html"),
    css = fs::path(dir_temp, "vega-embed.css")
  )

  file_block <- writeLines(block, manifest$block)

  text_index <-
    readLines(
      system.file("templates", "index.html", package = "vegawidget")
    )

  fn_glue <- function(text) {
    glue::glue_data(.x = list(spec = spec), text, .open = "{{", .close = "}}")
  }

  text_index <- vapply(text_index, fn_glue, "")

  file_index <- writeLines(text_index, manifest$index)

  fs::file_copy(
    system.file("templates", "vega-embed.css", package = "vegawidget"),
    manifest$css
  )

  gistr::gist_create_git(
    files = as.character(manifest),
    description = description,
    git_method = git_method
  )

}
