context("test-vega-versions.R")

test_that("get_vega_versions errors correctly", {
  skip_on_cran()

  expect_error(get_vega_versions("foo"), "Failed to retrieve Vega-Lite manifest")
})

test_that("get_vega_versions works correctly", {

  skip_on_cran()

  vega_vers <- list(
    vega_lite = "2.5.0",
    vega = "4.0.0-rc.2",
    vega_embed = "3.14.0"
  )

  expect_identical(get_vega_versions("2.5.0"), vega_vers)

})

test_that("vega_versions works correctly", {

  vega_versions <- vega_versions()

  expect_identical(
    names(vega_versions),
    c("vega_lite", "vega", "vega_embed")
  )

  expect_true(all(is.character(unlist(vega_versions))))

  expect_identical(get_major("2.3.0"), "2")

})
