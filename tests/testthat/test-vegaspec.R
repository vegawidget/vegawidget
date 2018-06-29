context("test-vegaspec.R")

spec_list <- list(a = 1, b = "foo")
spec_char <- '{"a": 1, "b": "foo"}'
spec_json <- jsonlite::toJSON(spec_list, auto_unbox = TRUE, pretty = TRUE)

test_that("as_vegaspec translates", {
  expect_identical(as_vegaspec(spec_list), spec_json)
  expect_identical(as_vegaspec(spec_char), spec_json)
})

