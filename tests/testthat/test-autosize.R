# borrowed from ggvega
normalize <- function(x) {

  if (length(x) <= 1L && !is.list(x)) {
    return(x)
  }

  names_x <- names(x)

  # if named, alphabetize
  if (!is.null(names_x)) {
    x <- x[order(names(x))]
  }

  x <- purrr::map(x, normalize)

  x
}

# create a multiple-view spec
# ===
spec_mtcars_hconcat <- spec_mtcars

hconcat_elem <-
  list(
    data = spec_mtcars_hconcat$data,
    mark = spec_mtcars_hconcat$mark,
    encoding = spec_mtcars_hconcat$encoding
  )

spec_mtcars_hconcat$hconcat <- list(hconcat_elem, hconcat_elem)

spec_mtcars_hconcat$data <- NULL
spec_mtcars_hconcat$mark <- NULL
spec_mtcars_hconcat$encoding <- NULL
# ===

# create an autosize spec
# ===
spec_mtcars_autosize <- spec_mtcars

spec_mtcars_autosize$config <-
  list(
    autosize = list(type = "fit", contains = "padding"),
    view = list(width = 300L, height = 300L)
  )
# ===

has_node <- unname(nchar(Sys.which("node")) > 0L)

test_that("autosize works", {

  expect_identical(
    normalize(vw_autosize(spec_mtcars, width = 300, height = 300)),
    normalize(spec_mtcars_autosize)
  )

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  vgspec_mtcars <- vw_to_vega(spec_mtcars)

  # autosize works on Vega (vs Vega-Lite)
  expect_identical(
    normalize(vw_autosize(vgspec_mtcars, width = 300, height = 300)),
    normalize(vw_to_vega(spec_mtcars_autosize))
  )
})

