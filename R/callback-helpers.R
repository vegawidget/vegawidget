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
vw_fetch <- function(url, options = NULL) {

  # temp file, deleted when function exits
  tmpfile <- withr::local_tempfile()
  utils::download.file(url, destfile = tmpfile, quiet = TRUE)

  vw_load(tmpfile)
}

#' @rdname vw_fetch
#' @export
#'
vw_load <- function(filename) {

  lines <- readLines(filename, encoding = "UTF-8")

  paste(lines, collapse = "\n")
}
