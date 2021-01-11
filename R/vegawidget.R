#' Create a Vega/Vega-Lite htmlwidget
#'
#' The main use of this package is to render a `vegawidget`,
#' which is also an `htmlwidget`. This function builds a `vegawidget`
#' using a `vegaspec`.
#'
#' If `embed` is `NULL`, `vegawidget()` uses:
#'
#' - `getOption("vega.embed")`, if that is NULL:
#' - an empty call to [vega_embed()]
#'
#' The most-important arguments to [vega_embed()] are:
#'
#' - `renderer`, to specify `"canvas"` (default) or `"svg"`
#' - `actions`,  to specify action-links
#'    for `export`, `source`, `compiled`, and `editor`
#'
#' If either `width` or `height` is specified, the `autosize()` function
#' is used to override the width and height of the `spec`. There are some
#' important provisions:
#'
#' - Specifying `width` and `height` is
#' [effective only for single-view charts and layered charts](
#' https://vega.github.io/vega-lite/docs/size.html#limitations).
#' It will not work for concatenated, faceted, or repeated charts.
#'
#' - In the `spec`, the default interpretation of width and height
#' is to describe the dimensions of the
#' **plotting rectangle**, not including the space used by the axes, labels,
#' etc. Here, `width` and `height` describe the dimensions
#' of the **entire** rendered chart, including axes, labels, etc.
#'
#' Please note that if you are using a remote URL to refer to a dataset in
#' your vegaspec, it may not render properly in the RStudio IDE,
#' due to a security policy set by RStudio. If you open the chart in a
#' browser, it should render properly.
#'
#' @inheritParams as_vegaspec
#' @inheritParams vw_autosize
#' @param embed   `list` to specify
#'   [vega-embed](https://github.com/vega/vega-embed#options) options,
#'   see **Details** on how this is set if `NULL`.
#' @param elementId `character`, explicit element ID for the vegawidget,
#'   useful if you have other JavaScript that needs to explicitly
#'   discover and interact with a specific vegawidget
#' @param base_url `character`, the base URL to prepend to data-URL elements
#'   in the vegaspec. This could be the path
#'   to a local directory that contains a local file referenced in the spec.
#'   It could be the base for a remote URL. Please note that by specifying
#'   the `base_url` here, you will override any `loader` that you specify
#'   using `vega_embed()`. Please note that this does not work with
#'   `knitr`. See examples.
#' @param ... other arguments passed to [htmlwidgets::createWidget()]
#'
#' @return S3 object of class `vegawidget` and `htmlwidget`
#' @seealso [vega-embed options](https://github.com/vega/vega-embed#options),
#'   [vega_embed()], [vw_autosize()]
#' @examples
#'   vegawidget(spec_mtcars, width = 350, height = 350)
#'
#'   # vegaspec with a data URL
#'   spec_precip <-
#'     list(
#'       `$schema` = vega_schema(),
#'       data = list(url = "seattle-weather.csv"),
#'       mark = "tick",
#'       encoding = list(
#'         x = list(field = "precipitation", type = "quantitative")
#'       )
#'     ) %>%
#'     as_vegaspec()
#'
#'   # define local path to file
#'   path_local <- system.file("example-data", package = "vegawidget")
#'
#'   # render using local path (does not work with knitr)
#'   vegawidget(spec_precip, base_url = path_local)
#'
#'\dontrun{
#'   # requires network-access
#'
#'   # define remote path to file
#'   url_remote <- "https://vega.github.io/vega-datasets/data"
#'
#'   # render using remote path
#'   # note: does not render in RStudio IDE; open using browser
#'   vegawidget(spec_precip, base_url = url_remote)
#'}
#' @export
#'
vegawidget <- function(spec, embed = NULL, width = NULL, height = NULL,
                       elementId = NULL, base_url = NULL, ...) {

  # if `embed` is NULL, check for option
  embed <- embed %||% getOption("vega.embed")

  # if `embed` is still NULL, set using empty call to vega_embed()
  embed <- embed %||% vega_embed()

  # set width, height if available from an option
  width <- width %||% getOption("vega.width")
  height <- height %||% getOption("vega.height")

  # autosize (if needed)
  spec <- vw_autosize(spec, width = width, height = height)

  ## base_url
  #
  # if `base_url` is specified here, it overrides the loader specified
  # in `embed`

  # if specified, set base_url in embed-loader
  if (!is.null(base_url)) {
    embed[["loader"]] <- embed[["loader"]] %||% list()
    embed[["loader"]][["baseURL"]] <- base_url
  }

  # check for `baseURL` in `embed[["loader"]]`
  baseURL <- embed[["loader"]][["baseURL"]]

  # if base_url is a local directory need to create a dependency
  if (!is.null(baseURL) && dir.exists(baseURL)) {

    # warn if knitr is active
    if (isTRUE(getOption('knitr.in.progress'))) {
      warning("attaching local data files does not work with knitr")
    }

    # make sure that all the URL's in the spec will be sensible
    urls <- .find_urls(spec)
    full_urls <- file.path(normalizePath(baseURL), urls)
    if (any(!file.exists(full_urls))) {
      stop(
        "Local file suggested by base_url and urls in spec does not exist:",
        full_urls[which(!file.exists(full_urls))]
      )
    }

    # set data-dependency for this chart
    get_md5 <- function(file) {
      digest::digest(algo = "md5", file = file)
    }

    # get list, key: filename, value: md5 of file
    files_md5 <- lapply(full_urls, get_md5)

    # get md5 of list
    data_md5 <- digest::digest(files_md5, algo = "md5")

    # get "unique" suffix for data
    suffix <- elementId %||% data_md5

    data_dependency <- htmltools::htmlDependency(
      name = glue::glue("data-{suffix}"),
      version = "0.0.0",
      src = c(file = normalizePath(baseURL)),
      attachment = basename(full_urls),
      all_files = FALSE
    )
    # set loader to refer to new location
    embed[["loader"]][["baseURL"]] <- glue::glue("lib/data-{suffix}-0.0.0/")
  } else {
    data_dependency <- NULL
  }

  # use internal methods here because spec has already been validated

  x <- list(
    chart_spec = .as_list(spec),
    embed_options = embed
  )

  x <- .as_json(x)

  vegawidget <-
    htmlwidgets::createWidget(
      "vegawidget",
      x,
      width = width,
      height = height,
      package = "vegawidget",
      sizingPolicy = htmlwidgets::sizingPolicy(
        defaultWidth = "auto",
        defaultHeight = "auto",
        viewer.fill = FALSE,
        knitr.figure = FALSE
      ),
      elementId = elementId,
      # Note -- this blocks the user from being able to specify additional
      # dependencies themselves through ... but there likely wouldn't be
      # reason to do so...
      dependencies = data_dependency,
      ...
    )

  vegawidget
}

#' Shiny-output for vegawidget
#'
#' Use this function in the UI part of your Shiny app.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{"100\%"},
#'   \code{"400px"}, \code{"auto"}) or a number, which will be coerced to a
#'   string and have \code{"px"} appended. For vegawidgets, `"auto"` is useful
#'   because, as of now, the spec determines the size of the widget, then the
#'   widget determines the size of the container.
#'
#' @export
#'
vegawidgetOutput <- function(outputId, width = "auto", height = "auto") {

  assert_packages("shiny")

  htmlwidgets::shinyWidgetOutput(
    outputId,
    "vegawidget",
    width,
    height,
    package = "vegawidget"
  )
}

#' Render shiny-output for vegawidget
#'
#' Use this function in the server part of your Shiny app.
#'
#' @param expr expression that generates a vegawidget. This can be
#'   a `vegawidget` or a `vegaspec`.
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @export
#'
renderVegawidget <- function(expr, env = parent.frame(), quoted = FALSE) {

  assert_packages("shiny")

  # if sent a vegaspec, convert to a vegawidget
  if (inherits(expr, "vegaspec")) {
    expr <- vegawidget(expr)
  }

  if (!quoted) { expr <- substitute(expr) } # force quoted

  htmlwidgets::shinyRenderWidget(
    expr,
    vegawidgetOutput,
    env,
    quoted = TRUE
  )
}
