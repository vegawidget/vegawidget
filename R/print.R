# see zzz.R for "creation" of the alt object

#' @inheritParams vegawidget
#' @seealso [vegawidget()]
#' @export
print.vegaspec <- function(x, embed = NULL, width = NULL, height = NULL, ...) {
  print(vegawidget(x, embed = NULL, width = NULL, height = NULL, ...))

  invisible(x)
}

#' @export
format.vegaspec <- function(x, ...) {
  as_json(x)
}

#' Knit-print method
#'
#' The only effective sizing options are `vega.width` and `vega.height`;
#' these are passed to [vegawidget()] as `width` and `height`,
#' respectively.
#'
#' Embedding options can be passed by setting the option `vega.embed` using
#' [vega_embed()].
#'
#' `vega.width` and `vega.height` are
#' coerced to numeric, so it is ineffective to specify a percentage.
#'
#' @inheritParams as_vegaspec
#' @param ... other arguments
#' @param options `list`, knitr options
#'
#' @export
#'
knit_print.vegaspec <- function(spec, ..., options = NULL){

  # it is ineffective to set out.width or out.height as a percentage
  to_num <- function(x) {

    if (is.null(x)) {
      return(NULL)
    }

    suppressWarnings({
      x_num <- as.numeric(x)
    })

    if (is.na(x_num)) {
      return(NULL)
    }

    x_num
  }

  embed <- options$vega.embed
  width <- to_num(options$vega.width)
  height <- to_num(options$vega.height)

  knitr::knit_print(
    vegawidget(spec, embed = embed, width = width, height = height)
  )
}
