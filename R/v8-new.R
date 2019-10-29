# functions to play around in V8

test_v8 <- function(url) {
  ctx <- V8::v8()
  ctx$source(system.file("bin/vw_fetch.js", package = "vegawidget"))

  ctx$eval(glue::glue("vwFetch('{url}').then(console.log)"))

  invisible(NULL)
}

test_node_fetch <- function(url = NULL) {

  url <- url %||% "https://pages.github.schneider-electric.com/r-sqd/se.datasets/data/site_progress.json"

  script_path <- system.file("bin/fetch-test.js", package = "vegawidget")

  res <-
    processx::run(
      "node",
      args = c(script_path, url)
    )
}
