context("test-vegaspec.R")

library("magrittr")

test_that("as_vegaspec translates", {

  spec_ref <- spec_mtcars %>% as_json() %>% as_vegaspec()

  spec_list <- as_list(spec_ref)
  spec_json <- as_json(spec_ref)
  spec_char <- as_character(spec_ref)

  expect_identical(as_vegaspec(spec_ref), spec_ref)
  expect_identical(as_vegaspec(spec_list), spec_ref)
  expect_identical(as_vegaspec(spec_json), spec_ref)
  expect_identical(as_vegaspec(spec_char), spec_ref)

})

test_that("class is correct", {

  expect_is(
    as_vegaspec(unclass(spec_mtcars)),
    c("vegaspec_vegalite", "vegaspec")
  )

  expect_is(
    to_vega(spec_mtcars),
    c("vegaspec_vega", "vegaspec")
  )

})




