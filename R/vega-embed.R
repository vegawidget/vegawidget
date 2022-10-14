#' Vega embed options
#'
#' Helper-function to specify the `embed` argument to `vegawidget()`.
#' These arguments reflect the options to the
#' [vega-embed](https://github.com/vega/vega-embed/#options)
#' library, which ultimately renders the chart specification as HTML.
#'
#' The most important arguments are `renderer`, `actions`, and `defaultStyle`:
#'
#' - The default `renderer` is `"canvas"`.
#'
#' - The default for `actions` is `NULL`, which means that the `export`,
#' `source`, and `editor` links are shown, but the `compiled` link is
#' not shown.
#'   - To suppress all action links, call with `actions = FALSE`.
#'   - To change from the default for a given action link, call with a list:
#'     `actions = list(editor = FALSE)`.
#'
#' - The default for `defaultStyle` is `TRUE`, which means that action-links
#' are rendered in a widget at the upper-right corner of the rendered chart.
#'
#' The [vega-embed](https://github.com/vega/vega-embed/#options) library has a lot
#' more options, you can supply these as names arguments using `...`.
#'
#' For example, it is ineffective to set the `width` and `height` parameters
#' here when embedding a Vega-Lite specification, as they will be overridden
#' by the value in the chart specification.
#'
#' @param renderer `character` the renderer to use for the view.
#'   One of `"canvas"` (default) or `"svg"`.
#'   See [Vega docs](https://vega.github.io/vega/docs/api/view/#view_renderer)
#'   for details.
#' @param actions `logical` or named vector of logicals, determines if action links
#'   ("Export as PNG/SVG", "View Source", "Open in Vega Editor")
#'   are included with the embedded view.
#'   If the value is `TRUE` (default), all action links will be shown
#'   and none if the value is `FALSE`. This property can be a named vector of
#'   logicals that maps
#'   keys (`export`, `source`, `compiled`, `editor`) to logical values for determining
#'   if each action link should be shown. By default, `export`, `source`,
#'   and `editor` are `TRUE` and `compiled` is `FALSE`, but these defaults
#'   can be overridden. For example, if `actions` is
#'   `list(export =  FALSE, source = TRUE)`, the embedded visualization will
#'   have two links – "View Source" and "Open in Vega Editor".
#' @param defaultStyle `logical` or `character`
#'   default stylesheet for embed actions. If set to `TRUE` (default),
#'   the embed actions are shown in a menu. Set to `FALSE` to use simple links.
#'   Provide a `character` string to set the style sheet.
#' @param config `character` or `list`, a URL string from which to load
#'   a Vega/Vega-Lite or Vega-Lite configuration file, or a `list` of
#'   Vega/Vega-Lite configurations to override the default configuration
#'   options. If `config` is a URL, it will be subject to standard browser
#'   security restrictions. Typically this URL will point to a file on the same
#'   host and port number as the web page itself.
#' @param patch	`JS` function, `list` or `character`, A function to modify the
#'   Vega specification before it is parsed. Alternatively, an `list` that,
#'   when compiled to JSON, will meet
#'   [JSON-Patch RFC6902](https://www.rfc-editor.org/rfc/rfc6902).
#'   If you use Vega-Lite, the compiled Vega will be patched.
#'   Alternatively to the function or the `list`, a URL string from which to
#'   load the patch can be provided. This URL will be subject to standard
#'   browser security restrictions. Typically this URL will point to a file
#'   on the same host and port number as the web page itself.
#' @param bind `character`
#' @param ... other named items, outlined in
#'   [vega-embed](https://github.com/vega/vega-embed) options.
#'
#' @seealso [vega-embed library](https://github.com/vega/vega-embed),
#'   [vegawidget()]
#'
#' @examples
#' vega_embed(renderer = "svg")
#'
#' @return `list` to to be used with vega-embed JavaScript library
#' @export
#'
vega_embed <- function(renderer = c("canvas", "svg"), actions = NULL,
                       defaultStyle = TRUE, config = NULL, patch = NULL,
                       bind = NULL, ...) {

  renderer <- match.arg(renderer)

  actions <- validate_actions(actions)

  options <-
    list(
      renderer = renderer,
      actions = actions,
      defaultStyle = defaultStyle,
      config = config,
      patch = patch,
      bind = bind,
      ...
    )

  embed_options <- list_remove_null(options)

  embed_options
}

list_remove_null <- function(x) {

  # determine which elements are NULL
  is_null <- vapply(x, is.null, logical(1))

  # remove them by settiing them to NULL (!?!)
  x[is_null] <- NULL

  x
}

validate_actions <- function(actions) {

  is_null_or_logical <- function(x) {
    rlang::is_null(x) || rlang::is_scalar_logical(x)
  }

  assert_null_or_logical <- function(x, name) {
    assertthat::assert_that(
      is_null_or_logical(x),
      msg = glue::glue(
        "vega-embed actions: value of `{name}` not NULL or scalar logical."
      )
    )
  }

  assert_named <- function(x) {
    assertthat::assert_that(
      !is.null(names(x)),
      msg = glue::glue("vega-embed actions: lists must be named.")
    )
  }

  assert_name_legal <- function(name, legal_names) {
    assertthat::assert_that(
      name %in% legal_names,
      msg = glue::glue("vega-embed actions: `{name}` is not a legal name.")
    )
  }

  # if NULL or scalar logical, all is well - return
  if (is_null_or_logical(actions)) {
    return(actions)
  }

  # coerce to list and test
  actions <- as.list(actions)

  # check names
  names_not_export <- c("source", "compiled", "editor")
  names_actions_legal <- c("export", names_not_export)
  assert_named(actions)
  purrr::walk(names(actions), assert_name_legal, names_actions_legal)

  # check source, compiled, editor
  actions_not_export <- actions[names_not_export]
  purrr::iwalk(actions_not_export, assert_null_or_logical)

  # check actions$export
  if (!rlang::is_null(actions$export)) {
    names_export_legal <- c("svg", "png")
    assert_named(actions$export)
    purrr::walk(names(actions$export), assert_name_legal, names_export_legal)
    purrr::iwalk(actions$export, assert_null_or_logical)
  }

  actions
}
