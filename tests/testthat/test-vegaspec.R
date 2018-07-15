context("test-vegaspec.R")

test_that("as_vegaspec translates", {

  spec_list <- unclass(spec_mtcars)
  spec_json <- .as_json(spec_list)
  spec_char <- unclass(.as_json(spec_list))

  expect_identical(as_vegaspec(spec_mtcars), spec_mtcars)
  expect_identical(as_vegaspec(spec_list), spec_mtcars)

  # using equivalent because of integer/double translation
  expect_equivalent(as_vegaspec(spec_json), spec_mtcars)
  expect_equivalent(as_vegaspec(spec_char), spec_mtcars)

})

test_that("class is correct", {

  expect_is(
    as_vegaspec(unclass(spec_mtcars)),
    c("vegaspec_vegalite", "vegaspec")
  )

})




