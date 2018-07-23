#' Build a block directory
#'
#' @param path   `character`  path to an empty directory
#' @inheritParams block_create
#'
#' @return `character` path, called for side effects
#' @keywords internal
#' @export
#'
block_build_directory <-
  function(path, spec, embed = vega_embed(),
           versions = vega_versions(major = FALSE),
           .block = block_config(), readme = NULL,
           use_thumbnail = TRUE, use_preview = TRUE) {

  assert_packages("fs")

  # path directory exists
  assertthat::assert_that(
    fs::dir_exists(path),
    msg = glue::glue("path `{path}` directory does not exist")
  )

  # path directory is empty
  assertthat::assert_that(
    identical(length(fs::dir_ls(path)), 0L),
    msg = glue::glue("path `{path}` is not empty")
  )

  # validate spec, when available

  # block
  writeLines(.block, fs::path(path, ".block"))

  # spec
  spec <- as_json(spec, pretty = TRUE)
  writeLines(spec, fs::path(path, "spec.json"))

  # index
  writeLines(
    block_index(embed = embed, versions = versions),
    fs::path(path, "index.html")
  )

  # readme
  if (!is.null(readme)) {

    # if this is a file, read it
    is_con <- rlang::is_string(readme) && file.exists(readme)
    if (is_con) {
      readme <- readLines(readme)
    }

    writeLines(readme, fs::path(path, "README.md"))
  }

  # image
  if (use_thumbnail || use_preview) {
    assert_packages("magick")

    img <- to_png(spec, scale = 2)
    img <- png_bin(img)
    img <- magick::image_read(img)
  }

  # thumbnail
  if (use_thumbnail) {
    tmb <- magick::image_resize(img, geometry = "230x120")
    magick::image_write(tmb, fs::path(path, "thumbnail.png"), format = "png")
  }

  # preview
  if (use_preview) {
    pvw <- magick::image_resize(img, geometry = "960x500")
    magick::image_write(pvw, fs::path(path, "preview.png"), format = "png")
  }

  path
}

#' Specify the block configuration
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
block_config <- function(license = "mit", height = 500, scrolling = TRUE, border = TRUE){

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
#' @inheritParams block_create
#'
#' @return `character` text of `index.html`
#' @keywords internal
#' @export
#'
block_index <- function(embed = vega_embed(),
                        versions = vega_versions(major = FALSE)) {

  # use internal method because we this is not a spec
  embed <- .as_json(embed, pretty = FALSE)

  # data to interpolate into index.html
  data <- c(list(vega_embed_options = embed), versions)

  file <- system.file("block", "index.html", package = "vegawidget")

  text <- readLines(file)
  text <- paste(text, collapse = "\n")
  text <- glue::glue_data(data, text, .open = "{{", .close = "}}")
  text <- unclass(text) # glue-remover ;)

  text
}


