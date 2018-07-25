context("test-autosize.R")

# create a multiple-view spec
# ===
vw_ex_mtcars_hconcat <- vw_ex_mtcars

hconcat_elem <-
  list(
    data = vw_ex_mtcars_hconcat$data,
    mark = vw_ex_mtcars_hconcat$mark,
    encoding = vw_ex_mtcars_hconcat$encoding
  )

vw_ex_mtcars_hconcat$hconcat <- list(hconcat_elem, hconcat_elem)

vw_ex_mtcars_hconcat$data <- NULL
vw_ex_mtcars_hconcat$mark <- NULL
vw_ex_mtcars_hconcat$encoding <- NULL
# ===

# create an autosize spec
# ===
vw_ex_mtcars_autosize <- vw_ex_mtcars

vw_ex_mtcars_autosize$config <-
  list(
    autosize = list(type = "fit", contains = "padding"),
    view = list(width = 300L, height = 300L)
  )
# ===

test_that("is_multiple_view works", {
  expect_false(is_multiple_view(vw_ex_mtcars))
  expect_true(is_multiple_view(vw_ex_mtcars_hconcat))
})

test_that("autosize warns", {
  expect_warning(
    vw_autosize(vw_ex_mtcars_hconcat, width = 300),
    "no effect on rendering\\.$"
  )
})

test_that("autosize works", {

  vg_vw_ex_mtcars <- vw_to_vega(vw_ex_mtcars)

  expect_identical(
    vw_autosize(vw_ex_mtcars, width = 300, height = 300),
    vw_ex_mtcars_autosize
  )

  # autosize works on Vega (vs Vega-Lite)
  expect_identical(
    vw_autosize(vg_vw_ex_mtcars, width = 300, height = 300),
    vw_to_vega(vw_ex_mtcars_autosize)
  )
})

