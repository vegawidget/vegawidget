context("test-vega-version.R")

test_that("get_vega_version errors correctly", {
  skip_on_cran()

  expect_error(
    get_vega_version("foo"),
    "Failed to retrieve Vega-Lite manifest",
    class = "http_404"
  )
})

test_that("get_vega_version works correctly", {

  skip_on_cran()

  vega_vers <- list(
    vega_lite = "3.0.2",
    vega = "5.3.2",
    vega_embed = "4.0.0-rc1"
  )

  expect_identical(get_vega_version("3.0.2"), vega_vers)

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
