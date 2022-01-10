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



test_that("vega_version_available() works correctly", {

  vega_version_all <- vega_version_all()
  vega_version <- vega_version()
  vega_version_available <- vega_version_available()

  expect_s3_class(vega_version_available, 'data.frame')

  # keep this for later
  is_locked <- vw_env$is_locked

  vw_lock_set(FALSE)
  expect_identical(
    vega_version_all(),
    vega_version_available()
  )

  vw_lock_set(TRUE)
  all <- vega_version_all()
  expect_identical(
    all[all[["widget"]] == vw_env[["widget"]], ],
    vega_version_available()
  )

  # set it back to how it was found
  vw_lock_set(is_locked)
})


test_that("get_candidate() works", {

  exp_ca <- function(result, index, re_msg) {
    expect_identical(result$index, index)

    if (is.null(re_msg)) {
      expect_null(result$message)
    } else {
      expect_match(result$message, re_msg)
    }
  }

  exp_ca(get_candidate("5", c("5.2.0", "4.1.7")), 1L, NULL)
  exp_ca(get_candidate("4", c("5.2.0", "4.1.7")), 2L, NULL)
  exp_ca(get_candidate("6", c("5.2.0", "4.1.7")), 1L, "maximum")
  exp_ca(get_candidate("3", c("5.2.0", "4.1.7")), 2L, "minimum")

  exp_ca(get_candidate("5.21.0", c("5.21.0", "5.17.0")), 1L, NULL)
  exp_ca(get_candidate("5.01.0", c("5.21.0", "5.17.0")), 1L, NULL)
  exp_ca(get_candidate("5.22.0", c("5.21.0", "5.17.0")), 1L, NULL)

})

test_that("get_widget_string() works", {

  library("tibble")

  available <- tribble(
      ~widget, ~vega_lite,    ~vega,
        "vl5",    "5.2.0", "5.21.0",
        "vl4",    "4.1.7", "5.17.0"
  )

  expect_identical(get_widget_string("vega-lite", "5", available), "vl5")
  expect_identical(get_widget_string("vega", "5", available), "vl5")

  expect_warning(
    expect_identical(get_widget_string("vega-lite", "2", available), "vl4"),
    "minimum"
  )

  expect_warning(
    expect_identical(get_widget_string("vega-lite", "20", available), "vl5"),
    "maximum"
  )
})
