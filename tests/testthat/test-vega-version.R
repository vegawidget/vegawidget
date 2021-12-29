test_that("get_vega_version works correctly", {

  skip_on_cran()

  vega_vers <- list(
    vega_lite = "3.0.2",
    vega = "5.3.2",
    vega_embed = "4.0.0-rc1"
  )

  expect_identical(get_vega_version("3.0.2"), vega_vers)

})

test_that("vega_version() works correctly", {

  vega_version <- vega_version()

  expect_identical(
    names(vega_version),
    c("widget", "vega_lite", "vega", "vega_embed", "is_locked")
  )

  expect_identical(get_major(c("2.3.0", "3.2")), c("2", "3"))
  expect_identical(get_major(TRUE), TRUE)
  expect_identical(get_major("vl5"), "vl5")

})


test_that("vega_version_all() works correctly", {

  vega_version_all <- vega_version_all()

  expect_identical(
    names(vega_version_all),
    c("widget", "vega_lite", "vega", "vega_embed")
  )

  expect_s3_class(vega_version_all, 'data.frame')

})
