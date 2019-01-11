context("test-autosize.R")

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

test_that("is_multiple_view works", {
  expect_false(is_multiple_view(spec_mtcars))
  expect_true(is_multiple_view(spec_mtcars_hconcat))
})

test_that("autosize warns", {

  expect_warning(
    vw_autosize(spec_mtcars_hconcat, width = 300),
    "no effect on rendering\\.$"
  )
})

test_that("autosize works", {

  expect_identical(
    vw_autosize(spec_mtcars, width = 300, height = 300),
    spec_mtcars_autosize
  )

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  vgspec_mtcars <- vw_to_vega(spec_mtcars)

  # autosize works on Vega (vs Vega-Lite)
  expect_identical(
    vw_autosize(vgspec_mtcars, width = 300, height = 300),
    vw_to_vega(spec_mtcars_autosize)
  )
})

