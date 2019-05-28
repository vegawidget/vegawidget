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
#' required packages needed to be able to print to png are installed
#' (see [vw_write_png()]) then a static png will be printed instead.
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

  fmt <- knitr::opts_knit$get("rmarkdown.pandoc.to")
  if (knitr::is_html_output(fmt)) {
    knitr::knit_print(
      vegawidget(spec, embed = embed, width = width, height = height)
    )
  } else {
    # knitr's default screenshoting won't work due to incompatibility with
    # es6 JS code and webshot. Thus interecept here and do the conversion to
    # static image ourselves...
    tryCatch({
      f <- tempfile()
      on.exit({unlink(f)})
      knitr::opts_chunk$set(out.width = 100)
      vw_write_png(spec, path = f, width = width, height = height)
      res <- readBin(f, "raw", file.info(f)[, "size"])
      structure(
        list(image = res, extension = ".png"),
        class = "html_screenshot"
      )
    }, error = function(e) {
      err_msg <- c("Error printing vegawidget in non-HTML format:",
                       conditionMessage(e))
      knitr::knit_print(err_msg)}
    )
  }
}

# tells us if we are knitting or not (knot?)
is_knit <- function() {
  if (!requireNamespace("knitr", quietly = TRUE)) {
    return(FALSE)
  }

  !is.null(knitr::opts_knit$get("rmarkdown.pandoc.to"))
}
