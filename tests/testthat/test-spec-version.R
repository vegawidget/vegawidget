schema_vega <- "https://vega.github.io/schema/vega/v5.json"
schema_vega_lite <- "https://vega.github.io/schema/vega-lite/v5.json"

vega <- list(library = "vega", version = "5")
vega_lite <- list(library = "vega_lite", version = "5")

test_that("parse_schema warns", {

  empty <- list(library = "", version = "")

  expect_warning(
    expect_identical(parse_schema("NULL"), empty),
    "NULL$"
  )

  expect_warning(
    expect_identical(parse_schema("foo"), empty),
    "foo$"
  )

})

test_that("parse_schema works", {

  expect_identical(parse_schema(schema_vega), vega)
  expect_identical(parse_schema(schema_vega_lite), vega_lite)

})

test_that("vw_spec_version works", {

  expect_identical(vw_spec_version(spec_mtcars), vega_lite)

})

test_that("vega_schema works", {

  expect_snapshot(vega_schema())
  expect_snapshot(vega_schema("vega"))
  expect_snapshot(vega_schema("vega_lite", major = FALSE))
  expect_snapshot(vega_schema("vega_lite", version = "5.2.0"))

})
