#' Callback helpers
#'
#' These are used by V8 so that R can access the file-system and the network
#' so that external data can be accessed.
#'
#' Assumes the encoding is UTF-8.
#'
#' @param url `character`
#' @param options named `list`, not yet implemented
#' @param filename `character`
#'
#' @return `character` contents of the file or URL
#' @keywords internal
#' @export
#'
vw_fetch <- function(url, options = NULL, encoding = "UTF-8") {

  # in theory, the vega loader figures out if `url` is a local file or not
  # in practice, it thinks local files are remote, so it comes here.
  #   hence, we have to handle this ourselves - so we do.

  if (fs::file_exists(url)) {
    # local file
    tmpfile <- url
  } else {
    # remote file
    tmpfile <- withr::local_tempfile()
    utils::download.file(url, destfile = tmpfile, quiet = TRUE)
  }

  vw_load(tmpfile, encoding = encoding)
}

#' @rdname vw_fetch
#' @export
#'
vw_load <- function(filename, encoding = "UTF-8") {

  lines <- readLines(filename, warn = FALSE, encoding = "UTF-8")

  paste(lines, collapse = "\n")
}
