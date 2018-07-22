
#' Create a gist that can be used as a block
#'
#' These functions do the same thing: create a gist; they differ only in what
#' they return. `block_create()` returns a copy of `spec` so that it can be
#' used in a pipe; `block_create_gistid()` returns a list of information
#' about the newly-created gist.
#'
#' @inheritParams vegawidget
#' @param .block       `character`, YAML text for the `.block` file -
#'   use the helper function [block_config()] to specify block-configuration
#' @param versions       named `list` of `character`:
#'   names refer to JavaScript libraries `vega`, `vega_lite`, `vega_embed`,
#'   values are the tags for the versions to use in the block - use the
#'   helper function [vega_versions()] with `major = TRUE` to use the current
#'   major versions rather than the versions supported in this package
#' @param description   `character`, description for the gist
#' @param readme        `character`, single line, path to a markdown file;
#'   multiple lines, markdown text
#'   (not yet implemented)
#' @param use_thumbnail `logical`, indicates to include a thumbnail image
#'   (not yet implemented)
#' @param use_preview   `logical`, indicates to include a preview image
#'   (not yet implemented)
#' @param endpoint      `character`, base endpoint for GitHub API, defaults to
#'   `"https://api.github.com"`; useful to specify with GitHub Enterprise,
#'   e.g. `"https://github.acme.com/api/v3"`
#'   (not yet implemented)
#' @param git_method    `character`, use `"ssh"` or `"https"`
#' @param env_pat       `character`, name of environment variable that contains
#'   a GitHub PAT (Personal Access Token), defaults to `"GITHUB_PAT"`;
#'   Useful to specify with GitHub Enterprise, e.g. `"GITHUB_ACME_PAT"`
#'   (not yet implemented)
#' @param block_host    `character`, hostname of blocks server,
#'   defaults to `bl.ocks.org`
#' @param quiet          `logical`, indicates to supress messages
#' @param browse         `logical`, indicates to open browser to blocks web-page
#'   when complete
#'
#' @return Called for side effects
#' \describe{
#'   \item{`create_block()`}{returns an invisible copy of `spec`}
#'   \item{`create_block_gistid()`}{returns a list with elements:
#'     \describe{
#'       \item{`endpoint`}{`character`, git API endpiont}
#'       \item{`id`}{`character`, gist id}
#'     }
#'   }
#' }
#'
#' @seealso [Blocks documentation](https://bl.ocks.org/-/about),
#'  [gistr::gist_create_git()]
#' @export
#'
block_create <- function(spec, embed = vega_embed(), .block = block_config(),
                         versions = vega_versions(major = FALSE),
                         description = "", readme = NULL,
                         use_thumbnail = TRUE, use_preview = TRUE,
                         git_method = c("ssh", "https"), endpoint = NULL,
                         env_pat = NULL, block_host = NULL,
                         quiet = FALSE, browse = TRUE) {

  # pass along everything to .create_block()
  result <- do.call(.block_create, args = as.list(environment()))

  invisible(result$spec)
}

#' @rdname block_create
#' @export
#'
block_create_gistid <- function(spec, embed = vega_embed(), .block = block_config(),
                                versions = vega_versions(major = FALSE),
                                description = "", readme = NULL,
                                use_thumbnail = TRUE, use_preview = TRUE,
                                git_method = c("ssh", "https"), endpoint = NULL,
                                env_pat = NULL, block_host = NULL,
                                quiet = FALSE, browse = TRUE) {

  # pass along everything to .create_block()
  result <- do.call(.block_create, args = as.list(environment()))

  result[c("endpoint", "id")]
}

.block_create <- function(spec, embed = vega_embed(), .block = block_config(),
                          versions = vega_versions(major = FALSE),
                          description = "", readme = NULL,
                          use_thumbnail = TRUE, use_preview = TRUE,
                          git_method = c("ssh", "https"), endpoint = NULL,
                          env_pat = NULL, block_host = NULL,
                          quiet = FALSE, browse = TRUE) {

  # validate
  assert_packages("fs", "gistr")

  # create temporary directory
  dir_temp <- fs::path(tempdir(), glue::glue("block-{as.numeric(Sys.time())}"))
  fs::dir_create(dir_temp)

  # compose a temp directory to contain the gist files
  block_build_directory(
    dir_temp,
    spec = spec,
    embed = embed,
    versions = versions,
    .block = .block,
    readme = readme,
    use_thumbnail = use_thumbnail,
    use_preview = use_preview
  )

  # create the gist based on the temp directory
  files <- fs::dir_ls(dir_temp, all = TRUE) # ensures we include .block
  description <- description %||% ""

  gst <- suppressMessages(
    gistr::gist_create_git(
      files,
      description = description,
      browse = FALSE,
      git_method = git_method
    )
  )

  # result
  block_host <- block_host %||% "bl.ocks.org"
  result <- list(
    spec = spec,
    endpoint = gsub("^(.*)(/gists/.*)$", "\\1", gst$url),
    id = gst$id,
    url_gist = gst$html_url,
    url_block = glue::glue("https://{block_host}/{gst$id}")
  )

  # if indicated, message the gist URL and the blocks URL
  if (!quiet) {
    message(glue::glue("block url: {result$url_block}"))
    message(glue::glue(" gist url: {result$url_gist}"))
  }

  # if indicated, open the browser
  if (browse) {
    utils::browseURL(result$url_block)
  }

  # delete temporary directory
  unlink(dir_temp)

  invisible(result)
}



