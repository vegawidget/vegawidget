#' Set base URL
#'
#' @description
#' This is useful for specs where data is specified using a URL.
#' Using this function to set the base URL, you can specify the data URL
#' in specs using the relative path from the base.
#'
#' For example, this
#' [Vega-Lite example](https://vega.github.io/vega-lite/examples/point_2d.html)
#' uses the base URL `https://cdn.jsdelivr.net/npm/vega-datasets@2`. In a spec,
#' instead of specifying:
#'
#' ```
#' data = "https://cdn.jsdelivr.net/npm/vega-datasets@2/data/cars.json"
#' ```
#'
#' You can call:
#'
#' ```
#' vw_set_base_url("https://cdn.jsdelivr.net/npm/vega-datasets@2")
#' ```
#'
#' Then specify:
#'
#' ```
#' data = "data/cars.json"
#' ```
#'
#' This function sets the value of `getOption("vega-embed")$loader$baseURL`.
#' You need set it only once in a session or RMarkdown file.
#'
#' @param url `character` URL to use as the base URL.
#'
#' @return `character` called for side effects, it returns the previous value
#'   invisibly.
#'
#' @examples
#'  # this is the URL used for Vega datasets
#'  previous <- vw_set_base_url("https://cdn.jsdelivr.net/npm/vega-datasets@2")
#'
#'  # reset to previous value
#'  vw_set_base_url(previous)
#' @export
#'
vw_set_base_url <- function(url) {

  # validate that it's a single string
  assertthat::assert_that(
    assertthat::is.string(url) || is.null(url)
  )

  vega_embed_local <- getOption("vega.embed", default = list())

  url_old <- vega_embed_local[["loader"]][["baseURL"]]

  vega_embed_local[["loader"]][["baseURL"]] <- url

  options(vega.embed = vega_embed_local)

  invisible(url_old)
}
