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
#' @seealso [vw_autosize()], [vega_embed()]
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

  # if this goes to HTML, print and be done!
  if (knitr::is_html_output(fmt)) {
    return(
      knitr::knit_print(
        vegawidget(spec, embed = embed, width = width, height = height)
      )
    )
  }

  # this does not go to html; we have more thinking to do...

  # knitr's default screenshoting won't work due to incompatibility with
  # es6 JS code and webshot. Thus interecept here and do the conversion to
  # static image ourselves...

  # I don't know that we need this here, because knitr seems very good about
  # always supplying a value for `dev`.
  dev_default <- "svg"
  if (knitr::is_latex_output()) {
    dev_default <- "pdf"
  }

  dev <- options$dev %||% knitr::opts_chunk$get("dev") %||% dev_default

  # choose writing-function
  fn_write <- switch(
    dev,
    png = vw_write_png,
    svg = vw_write_svg,
    pdf = {
      assert_packages("rsvg")
      function(spec, path, ...) {
        svg <- vw_to_svg(spec, ...)
        rsvg::rsvg_pdf(charToRaw(svg), path)
      }
    },
    # default, if dev not recognized
    function(spec, path, ...) {
      stop("unknown device type: `", dev, "`.")
    }
  )

  tryCatch({
      f <- tempfile()
      on.exit({unlink(f)})
      fn_write(spec, path = f, width = width, height = height)
      res <- readBin(f, "raw", file.info(f)[, "size"])
      structure(
        list(image = res, extension = paste0(".", dev)),
        class = "html_screenshot"
      )
    },
    error = function(e) {
      err_msg <- c(
        "Error printing vegawidget in non-HTML format:",
        conditionMessage(e)
      )
      knitr::knit_print(err_msg)
    }
  )

}


