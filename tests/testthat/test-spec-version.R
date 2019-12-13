context("test-spec-version.R")

schema_vega <- "https://vega.github.io/schema/vega/v5.json"
schema_vega_lite <- "https://vega.github.io/schema/vega-lite/v4.json"

vega <- list(library = "vega", version = "5")
vega_lite <- list(library = "vega_lite", version = "4")

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

  expect_identical(.schema_type(schema_vega), vega)
  expect_identical(.schema_type(schema_vega_lite), vega_lite)

})

test_that("vw_spec_version works", {

  expect_identical(vw_spec_version(spec_mtcars), vega_lite)

})

test_that("vega_schema works", {

  expect_identical(vega_schema(), schema_vega_lite)
  expect_identical(vega_schema("vega"), schema_vega)

})
