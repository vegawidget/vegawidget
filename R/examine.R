#' Examine vegaspec
#'
#' This is a thin wrapper to [listviewer::jsonedit()],
#' used to interactvely examine a Vega or Vega-Lite specification.
#' It works a little differently than calling [listviewer::jsonedit()]
#' directly; it returns invisibly a copy of
#' `spec`, to support piping.
#'
#' @inheritParams listviewer::jsonedit
#' @inheritParams as_vegaspec
#'
#' @return invisible copy of `spec`, called for side-effect.
#' @examples
#'   vw_ex_mtcars_autosize <-
#'     vw_ex_mtcars %>%
#'     examine() %>%
#'     vw_autosize(width = 300, height = 300) %>%
#'     examine()
#' @export
#'
examine <- function(spec, mode = "tree",
                    modes = c("code", "form", "text", "tree", "view"),
                    ..., width = NULL, height = NULL,
                    elementId = NULL) {

  if (!requireNamespace("listviewer", quietly = TRUE)) {
    stop("Package \"listviewer\" needed for this function to work. Please install it.",
         call. = FALSE)
  }

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


