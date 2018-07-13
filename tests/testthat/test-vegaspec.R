context("test-vegaspec.R")

test_that("as_vegaspec translates", {

  spec_list <- list(a = 1L, b = "foo")
  spec_vegaspec <-
    structure(spec_list, class = c("vegaspec", class(spec_list)))

  spec_json <- as_json(spec_list)
  spec_char <- '{"a": 1, "b": "foo"}'

  spec_list_vegaspec <- as_vegaspec(spec_list)
  spec_json_vegaspec <- as_vegaspec(spec_json)
  spec_char_vegaspec <- as_vegaspec(spec_char)
  spec_vegaspec_vegaspec <- as_vegaspec(spec_vegaspec)

  expect_identical(spec_list_vegaspec, spec_vegaspec)
  expect_identical(spec_json_vegaspec, spec_vegaspec)
  expect_identical(spec_char_vegaspec, spec_vegaspec)
  expect_identical(spec_vegaspec_vegaspec, spec_vegaspec)

})




