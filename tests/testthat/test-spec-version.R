context("test-spec_type.R")

schema_vega <- "https://vega.github.io/schema/vega/v3.json"
schema_vegalite <- "https://vega.github.io/schema/vega-lite/v2.json"

test_that(".schema_type warns", {

  empty <- list(library = "", version = "")

  expect_warning(
    expect_identical(.schema_type("NULL"), empty),
    "NULL$"
  )

  expect_warning(
    expect_identical(.schema_type("foo"), empty),
    "foo$"
  )

})

test_that(".schema_type works", {

  vega <- list(library = "vega", version = "3")
  vegalite <- list(library = "vegalite", version = "2")

  expect_identical(.schema_type(schema_vega), vega)
  expect_identical(.schema_type(schema_vegalite), vegalite)

})

test_that("spec_version works", {

  vegalite <- list(library = "vegalite", version = "2")

  expect_identical(spec_version(spec_mtcars), vegalite)

})
