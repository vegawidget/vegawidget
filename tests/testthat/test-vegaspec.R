context("test-vegaspec.R")

data_test <-
  data.frame(
    a = c(1, 2, 3),
    b = c("A", "B", "C"),
    stringsAsFactors = FALSE
  )

test_that("as_vegaspec translates", {

  spec_list <- list(a = 1, b = "foo")
  spec_char <- '{"a": 1, "b": "foo"}'
  spec_json <-
'{
  "a": 1,
  "b": "foo"
}'

  spec_list_json <- as_vegaspec(spec_list, validate_spec = FALSE)
  spec_char_json <- as_vegaspec(spec_char, validate_spec = FALSE)

  expect_identical(as.character(spec_list_json), spec_json)
  expect_identical(as.character(spec_char_json), spec_json)

  expect_s3_class(spec_list_json, "json")
  expect_s3_class(spec_char_json, "json")
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
