context("test-vegaspec.R")

library("magrittr")

has_node <- unname(nchar(Sys.which("node")) > 0L)

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

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  expect_is(vw_to_vega(spec_mtcars), "list")
  expect_is(vw_to_vega(spec_mtcars), "vegaspec")
  expect_is(vw_to_vega(spec_mtcars), "vegaspec_vega")

})

test_that("vw_as_json handles NULLS", {

  spec_test <- list(
    `$schema` = "https://vega.github.io/schema/vega-lite/v2.json",
    width = NULL,
    height = NULL
  )

  spec_test_json <- vw_as_json(spec_test)

  expect_match(spec_test_json, '"width": null')
  expect_match(spec_test_json, '"height": null')

})

test_that("vegaspec without $schema warns and adds element", {

  spec_test <- list()

  # warning
  spec_ref <- expect_warning(as_vegaspec(spec_test))

  # check result
  expect_identical(
    spec_ref,
    as_vegaspec(list(`$schema` = vega_schema()))
  )

})





