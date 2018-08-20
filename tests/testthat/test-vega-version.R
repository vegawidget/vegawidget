context("test-vega-version.R")

test_that("get_vega_version errors correctly", {
  skip_on_cran()

  expect_error(get_vega_version("foo"), "Failed to retrieve Vega-Lite manifest")
})

test_that("get_vega_version works correctly", {

  skip_on_cran()

  vega_vers <- list(
    vega_lite = "2.6.0",
    vega = "4.0.0-rc.3",
    vega_embed = "3.16.0"
  )

  expect_identical(get_vega_version("2.6.0"), vega_vers)

})

test_that("vega_version works correctly", {

  vega_version <- vega_version()

  expect_identical(
    names(vega_version),
    c("vega_lite", "vega", "vega_embed")
  )

  expect_true(all(is.character(unlist(vega_version))))

  expect_identical(get_major("2.3.0"), "2")

})
