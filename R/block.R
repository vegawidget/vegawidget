#' Create a yaml string for a block
#'
#'
#' @param license   `character` specifies the license
#' @param height    `numeric` height of the block (pixels)
#' @param scrolling `logical` indicates to use scrolling bars
#' @param border    `logical` indicates to put a border on the `iframe`
#'
#' @return `character` yaml string for `.block` file
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

#' Create text for block index.html
#'
#' @inheritParams create_block
#'
#' @return `character` text of `index.html`
#' @keywords internal
#' @export
#'
block_index <- function(spec, embed = vega_embed(),
                        versions = vega_versions(major = FALSE)) {

  text_index <-
    readLines(
      system.file("block", "index.html", package = "vegawidget")
    )

  spec <- as_vegaspec(spec)
  spec <- .as_json(unclass(spec), pretty = TRUE)
  # add further indentation
  spec <- gsub("\n", "\n  ", spec)

  embed <- .as_json(embed, pretty = TRUE)
  # add further indentation
  embed <- gsub("\n", "\n  ", embed)

  data <- c(list(spec = spec, vega_embed_options = embed), versions)

  fn_glue <- function(text) {
    glue::glue_data(.x = data, text, .open = "{{", .close = "}}")
  }

  # iterate over each line in the text to interpolate
  text_index <- vapply(text_index, fn_glue, "", USE.NAMES = FALSE)

  # preserve empty lines
  my_strsplit <- function(x) {
    if (nchar(x) > 0){
      x <- strsplit(x, split = "\n")
    }

    x
  }

  text_index <- lapply(text_index, my_strsplit)

  text_index <- unlist(text_index)

  text_index
}

#' Create a gist that can be used as a block
#'
#' @param spec          `json`, `list`, or `character` Vega-Lite or Vega specification
#' @param embed         `vega_embed` object
#'   (not yet implemented)
#' @param block         `character` YAML text for the `.block` file
#' @param versions       named `list` of `character`:
#'   names refer to JavaScript libraries `vega`, `vega_lite`, `vega_embed`,
#'   values are the tags for the versions to use in the block - use the
#'   helper function [vega_versions()] with `major = TRUE` to use the current
#'   major versions rather than the versions supported in this package.
#' @param description   `character` description for the gist
#' @param readme        `character` single line, path to a markdown file;
#'   multiple lines, markdown text
#'   (not yet implemented)
#' @param use_thumbnail `logical` indicates to include a thumbnail image
#'   (not yet implemented)
#' @param use_preview   `logical` indicates to include a preview image
#'   (not yet implemented)
#' @param git_method    `character` use `"ssh"` or `"https"`
#' @param host `character`` Base endpoint for GitHub API, defaults to
#'   \code{"https://api.github.com"}. Useful to specify with GitHub Enterprise,
#'   e.g. \code{"https://github.acme.com/api/v3"}.
#'   (not yet implemented)
#' @param env_pat (character) Name of environment variable that contains
#'   a GitHub PAT (Personal Access Token), defaults to \code{"GITHUB_PAT"}.
#'   Useful to specify with GitHub Enterprise, e.g. \code{"GITHUB_ACME_PAT"}.
#'   (not yet implemented)
#'
#' @return called for side effects
#'
#' @seealso [Blocks documentation](https://bl.ocks.org/-/about),
#'  [gistr::gist_create_git()]
#' @export
#'
create_block <- function(spec, embed = vega_embed(), block = block_yaml(),
                         versions = vega_versions(major = FALSE),
                         description = NULL, readme = NULL,
                         use_thumbnail = TRUE, use_preview = TRUE,
                         git_method = c("ssh", "https"),
                         host = NULL, env_pat = NULL) {

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
  file_index <-
    writeLines(
      block_index(spec, embed = embed, versions = versions),
      manifest$index
    )

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
