
#' Create a gist that can be used as a block
#'
#' @inheritParams vegawidget
#' @param .block       `character` YAML text for the `.block` file -
#'   use the helper function [block_config()] to specify block-configuration
#' @param versions       named `list` of `character`:
#'   names refer to JavaScript libraries `vega`, `vega_lite`, `vega_embed`,
#'   values are the tags for the versions to use in the block - use the
#'   helper function [vega_versions()] with `major = TRUE` to use the current
#'   major versions rather than the versions supported in this package
#' @param description   `character` description for the gist
#' @param readme        `character` single line, path to a markdown file;
#'   multiple lines, markdown text
#'   (not yet implemented)
#' @param use_thumbnail `logical` indicates to include a thumbnail image
#'   (not yet implemented)
#' @param use_preview   `logical` indicates to include a preview image
#'   (not yet implemented)
#' @param endpoint      `character` base endpoint for GitHub API, defaults to
#'   `"https://api.github.com"`; useful to specify with GitHub Enterprise,
#'   e.g. `"https://github.acme.com/api/v3"`
#'   (not yet implemented)
#' @param git_method    `character` use `"ssh"` or `"https"`
#' @param env_pat       `character` name of environment variable that contains
#'   a GitHub PAT (Personal Access Token), defaults to `"GITHUB_PAT"`;
#'   Useful to specify with GitHub Enterprise, e.g. `"GITHUB_ACME_PAT"`
#'   (not yet implemented)
#' @param block_host    `character` hostname of blocks server,
#'   defaults to `bl.ocks.org`
#' @param message        `logical` indicates to print messages
#' @param browse         `logical` indicates to open browser to blocks web-page
#'   when complete
#'
#' @return copy of `spec`, called for side effects
#'
#' @seealso [Blocks documentation](https://bl.ocks.org/-/about),
#'  [gistr::gist_create_git()]
#' @export
#'
create_block <- function(spec, embed = vega_embed(), .block = block_config(),
                         versions = vega_versions(major = FALSE),
                         description = NULL, readme = NULL,
                         use_thumbnail = TRUE, use_preview = TRUE,
                         git_method = c("ssh", "https"), endpoint = NULL,
                         env_pat = NULL, block_host = NULL,
                         message = TRUE, browse = TRUE) {

  git_method <- match.arg(git_method)

  # create temporary directory
  dir_temp <- tempdir()

  # compose a temp directory to contain the gist files

  # create the gist based on the temp directory

  # if indicated, message the gist URL and the blocks URL

  # if indicated, open the browser

  # delete temporary directory
  unlink(dir_temp)

  invisible(spec)
}



