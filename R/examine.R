#' Examine vegaspec
#'
#' This is a thin wrapper to [listviewer::jsonedit()],
#' use to interactvely examine a Vega or Vega-Lite specification.
#'
#' @inheritParams listviewer::jsonedit
#' @inheritParams as_vegaspec
#'
#' @return S3 object of class `jsonedit` and `htmlwidget`
#' @examples
#'   vw_examine(spec_mtcars)
#'
#'   spec_mtcars_autosize <-
#'     spec_mtcars %>%
#'     vw_autosize(width = 300, height = 300)
#'
#'   vw_examine(spec_mtcars_autosize)
#' @export
#'
vw_examine <- function(spec, mode = "tree",
                       modes = c("code", "form", "text", "tree", "view"),
                       ..., width = NULL, height = NULL,
                       elementId = NULL) {

  assert_packages("listviewer")

  # I would prefer that this function print the htmlwidget and
  # invisibly return the spec, so as to support piping.
  #
  # However, doing this prevents the widget from being printed
  # when being knit. See https://github.com/vegawidget/vegawidget/issues/30
  #
  # To me, it is more important that this work well with knitr, than
  # that this be pipeable.
  #

  listviewer::jsonedit(
    listdata = spec,
    mode = mode,
    modes = modes,
    ...,
    width = width,
    height = height,
    elementId = elementId
  )
}


