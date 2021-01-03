test_that("vw_set_base_url() works", {

  get_base_url <- function() {
    getOption("vega.embed")[["loader"]][["baseURL"]]
  }

  # set the option
  vw_set_base_url("foo")
  expect_identical(get_base_url(), "foo")

  # set the option, expect the old option, silently
  expect_identical(
    expect_silent(vw_set_base_url("bar")),
    "foo"
  )

  # set the option to NULL
  vw_set_base_url(NULL)
  expect_identical(get_base_url(), NULL)

})
