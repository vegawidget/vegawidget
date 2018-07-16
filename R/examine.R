#' Examine a specification
#'
#' This function is a thin wrapper to [listviewer::jsonedit()];
#' use it to interactvely examine a Vega or Vega-Lite specification.
#'
#' @inheritParams listviewer::jsonedit
#' @inheritParams as_vegaspec
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

  spec <- as_json(spec)

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


