#' Create a yaml string for a block
#'
#'
#' @param license   `character` specifies the license
#' @param height    `numeric` height of the block (pixels)
#' @param scrolling `logical` indicates to use scrolling bars
#' @param border    `logical` indicates to put a border on the `iframe`
#'
#' @return `character` yaml string for `.block` file
#' @keywords internal
#' @seealso [Blocks documentation](https://bl.ocks.org/-/about)
#' @export
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

#' Create a gist that can be used as a block
#'
#' idea: function to validate the spec
#'
#' @param spec          `json`, `list`, or `character` Vega-Lite or Vega specification
#' @param embed         `vega_embed` object
#' @param description   `character` description for the gist
#' @param block         `character` YAML text for the `.block` file
#' @param readme        `character` single line, path to a markdown file;
#'   multiple lines, markdown text
#' @param use_thumbnail `logical` indicates to include a thumbnail image
#' @param use_preview   `logical` indicates to include a preview image
#' @param use_current   `logical` or named `list` of `logical`,
#'   for names of JavaScript libraries `vega`, `vega_lite`, `vega_embed`:
#'   - `TRUE`: use the current major version
#'   - `FALSE`: use the version use in the htmlwidget for this package
#' @param git_method    `character` use `"ssh"` or `"https"`
#' @param host          `character` host address,
#'   defaults to `"gist.github.com"`
#' @param auth_token    `character` GitHub PAT,
#'   defaults to `Sys.getenv("GITHUB_PAT")`
#'
#' @return called for side effects
#'
#' @seealso [Blocks documentation](https://bl.ocks.org/-/about),
#'  [gistr::gist_create_git()]
#' @export
#'
create_block <- function(spec, embed = vega_embed(), description = NULL,
                         block = block_yaml(), readme = NULL,
                         use_thumbnail = TRUE, use_preview = TRUE,
                         use_current = FALSE, git_method = c("ssh", "https"),
                         host = NULL, auth_token = NULL) {

  # validate packages and inputs
  assert_packages(c("gistr", "fs"))

  git_method <- match.arg(git_method)

  # define a manifest
  dir_temp <- tempdir()

  manifest <- list(
    block = fs::path(dir_temp, ".block"),
    index = fs::path(dir_temp, "index.html"),
    css = fs::path(dir_temp, "vega-embed.css")
  )

  # .block file
  file_block <- writeLines(block, manifest$block)

  # index.html file
  text_index <-
    readLines(
      system.file("templates", "index.html", package = "vegawidget")
    )

  fn_glue <- function(text) {
    glue::glue_data(.x = list(spec = spec), text, .open = "{{", .close = "}}")
  }

  # iterate over each line in the text to interpolate
  text_index <- vapply(text_index, fn_glue, "")

  file_index <- writeLines(text_index, manifest$index)

  # vega-embed.css file
  fs::file_copy(
    system.file("templates", "vega-embed.css", package = "vegawidget"),
    manifest$css
  )

  # create gist
  gistr::gist_create_git(
    files = as.character(manifest),
    description = description,
    git_method = git_method
  )

}
