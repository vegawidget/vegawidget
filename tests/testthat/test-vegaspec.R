context("test-vegaspec.R")

library("magrittr")

test_that("as_vegaspec translates", {

  # need to go to json and back because of data-frame in vw_ex_mtcars
  spec_ref <- spec_mtcars %>% vw_as_json() %>% as_vegaspec()
  spec_json <- vw_as_json(spec_ref)

  expect_identical(as_vegaspec(spec_ref), spec_ref)
  expect_identical(as_vegaspec(spec_json), spec_ref)

})

test_that("class is correct", {

  expect_is(as_vegaspec(unclass(spec_mtcars)), "list")
  expect_is(as_vegaspec(unclass(spec_mtcars)), "vegaspec")
  expect_is(as_vegaspec(unclass(spec_mtcars)), "vegaspec_vega_lite")

  expect_is(vw_to_vega(spec_mtcars), "list")
  expect_is(vw_to_vega(spec_mtcars), "vegaspec")
  expect_is(vw_to_vega(spec_mtcars), "vegaspec_vega")

})




