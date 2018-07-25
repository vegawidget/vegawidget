context("test-vegaspec.R")

library("magrittr")

test_that("as_vegaspec translates", {

  # need to go to json and back because of data-frame in vw_ex_mtcars
  spec_ref <- vw_ex_mtcars %>% vw_as_json() %>% as_vegaspec()
  spec_json <- vw_as_json(spec_ref)

  expect_identical(as_vegaspec(spec_ref), spec_ref)
  expect_identical(as_vegaspec(spec_json), spec_ref)

})

test_that("class is correct", {

  expect_is(as_vegaspec(unclass(vw_ex_mtcars)), "list")
  expect_is(as_vegaspec(unclass(vw_ex_mtcars)), "vegaspec")
  expect_is(as_vegaspec(unclass(vw_ex_mtcars)), "vegaspec_vega_lite")

  expect_is(to_vega(vw_ex_mtcars), "list")
  expect_is(to_vega(vw_ex_mtcars), "vegaspec")
  expect_is(to_vega(vw_ex_mtcars), "vegaspec_vega")

})




