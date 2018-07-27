#' Examine vegaspec
#'
#' This is a thin wrapper to [listviewer::jsonedit()],
#' use to interactvely examine a Vega or Vega-Lite specification.
#'
#' This function works a little differently than calling
#' [listviewer::jsonedit()] directly; it returns invisibly a copy of
#' `spec`, to support piping.
#'
#' @inheritParams listviewer::jsonedit
#' @inheritParams as_vegaspec
#'
#' @return invisible copy of `spec`, called for side-effect.
#' @examples
#'   vw_examine(spec_mtcars)
#'
#'   spec_mtcars_autosize <-
#'     spec_mtcars %>%
#'     vw_autosize(width = 300, height = 300) %>%
#'     vw_examine()
#' @export
#'
vw_examine <- function(spec, mode = "tree",
                       modes = c("code", "form", "text", "tree", "view"),
                       ..., width = NULL, height = NULL,
                       elementId = NULL) {

  assert_packages("listviewer")

  print(
    listviewer::jsonedit(
      listdata = spec,
      mode = mode,
      modes = modes,
      ...,
      width = width,
      height = height,
      elementId = elementId
    )
  )

  invisible(spec)
}


