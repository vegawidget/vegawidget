# see zzz.R for "creation" of the alt object

#' @export
print.vegaspec <- function(x, ...) {
  print(vegawidget(x, ...))

  invisible(x)
}

#' @export
format.vegaspec <- function(x, ...) {
  vw_as_json(x)
}

#' Knit-print method
#'
#' Currently, the only supported options are `vega.width`,
#' `vega.height` (as pixels) and `vega.embed` (as a list).
#'
#' When knitting to an HTML-based format, the `spec` is rendered as normal.
#'
#' When knitting to an non-html format, if the
#' [**webshot**](https://cran.r-project.org/package=webshot) package
#' and PhantomJS are installed, an image will be generated instead. You
#' may find [webshot::install_phantomjs()] to be useful.
#'
#' This function has potential to be developed further; it
#' calls [vegawidget()] using the options `vega.width`,
#' `vega.height` and `vega.embed`:
#'
#'  - `vega.width` and `vega.height` are passed to [vegawidget()]
#'  as `width` and `height`, respectively. These are
#'  coerced to numeric, so it is ineffective to specify a percentage.
#'
#'  - `vega.embed` is passed to [vegawidget()] as `embed`. The function
#'  [vega_embed()] can be useful to set `vega.embed`.
#'
#' @inheritParams as_vegaspec
#' @param ... other arguments
#' @param options `list`, knitr options
#'
#' @seealso [webshot::install_phantomjs()], [vw_autosize()], [vega_embed()]
#' @export
#'
knit_print.vegaspec <- function(spec, ..., options = NULL){

  # it is ineffective to set out.width or out.height as a percentage
  to_int <- function(x) {

    if (is.null(x)) {
      return(NULL)
    }

    suppressWarnings({
      x_int <- as.integer(x)
    })

    if (is.na(x_int)) {
      return(NULL)
    }

    x_int
  }

  embed <- options$vega.embed
  width <- to_int(options$vega.width)
  height <- to_int(options$vega.height)

  knitr::knit_print(
    vegawidget(spec, embed = embed, width = width, height = height)
  )
}

# tells us if we are knitting or not (knot?)
is_knit <- function() {
  if (!requireNamespace("knitr", quietly = TRUE)) {
    return(FALSE)
  }

  !is.null(knitr::opts_knit$get("rmarkdown.pandoc.to"))
}
