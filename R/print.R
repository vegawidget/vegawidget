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
#' If you are knitting to an HTML-based format, the only supported options are
#' `vega.width`, `vega.height` (as pixels) and `vega.embed` (as a list).
#' If you are knitting to a non-HTML-based format, you additionally
#' have the options `dev`, `out.width` and `out.height` available.
#'
#' The biggest thing to keep in mind about a Vega visualization is that
#' very often, the chart tells you how much space it needs, rather
#' than than you tell it how much space it has available. In the future, it
#' may reveal itself how to manage better this "conversation".
#'
#' @section HTML-based:
#' When knitting to an HTML-based format, the `spec` is rendered as normal,
#' it calls [vegawidget()] using the options `vega.width`, `vega.height`
#' and `vega.embed`:
#'
#'  - `vega.width` and `vega.height` are passed to [vegawidget()]
#'  as `width` and `height`, respectively. These values are coerced to numeric,
#'  so it is ineffective to specify a percentage. They are passed to
#'  [vw_autosize()] to resize the chart, if
#'  [possible](https://vega.github.io/vega-lite/docs/size.html#limitations).
#'
#'  - `vega.embed` is passed to [vegawidget()] as `embed`. The function
#'  [vega_embed()] can be useful to set `vega.embed`.
#'
#' @section Non-HTML-based:
#' When knitting to an non-HTML-based format, e.g. `github_document` or
#' `pdf_document`, this function will convert the chart to an image, then knitr
#' will incorporate the image into your document. You have the additional
#' knitr options `dev`, `out.width`, and `out.height`:
#'
#'  - The supported values of `dev` are `"png"`, `"svg"`, and `"pdf"`. If you
#'   are knitting to a LaTeX format (e.g. `pdf_document`) and you specify `dev`
#'   as `"svg"`, it will be implemented as `"pdf"`.
#'
#'  - To scale the image within your document, you can use  `out.width` or
#'  `out.height`. Because the image will already have an aspect ratio,
#'  it is recommended to specify no more than one of these.
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

  # if this goes to HTML, print and be done!
  if (knitr::is_html_output(excludes = c("markdown", "epub", "gfm"))) {
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

  # determine the graphics-device
  dev <- options$dev %||% knitr::opts_chunk$get("dev")

  # if specifying svg and using LaTeX, use pdf
  if (identical(dev, "svg") && knitr::is_latex_output()) {
    dev <- "pdf"
  }

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


