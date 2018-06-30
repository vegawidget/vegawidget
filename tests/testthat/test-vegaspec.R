context("test-vegaspec.R")

data_test <-
  data.frame(
    a = c(1, 2, 3),
    b = c("A", "B", "C"),
    stringsAsFactors = FALSE
  )

test_that("as_vegaspec translates", {

  spec_list <- list(a = 1L, b = "foo")
  spec_vegaspec <-
    structure(spec_list, class = c("vegaspec", class(spec_list)))

  spec_json <- as_json(spec_list)
  spec_char <- '{"a": 1, "b": "foo"}'

  spec_list_vegaspec <- as_vegaspec(spec_list, validate = FALSE)
  spec_json_vegaspec <- as_vegaspec(spec_json, validate = FALSE)
  spec_char_vegaspec <- as_vegaspec(spec_char, validate = FALSE)

  expect_identical(spec_list_vegaspec, spec_vegaspec)
  expect_identical(spec_json_vegaspec, spec_vegaspec)
  expect_identical(spec_char_vegaspec, spec_vegaspec)

})

test_that("data-frame serialization works", {

  json_test <-
'[
  {
    "a": 1,
    "b": "A"
  },
  {
    "a": 2,
    "b": "B"
  },
  {
    "a": 3,
    "b": "C"
  }
]'

  expect_identical(as.character(as_json(data_test)), json_test)

})
