context("to-vega")

library("magrittr")

test_that("vw_to_vega works", {

  skip_on_cran() # Need to have node installed

  spec_mtcars_vega <-
    "../spec/spec_mtcars.vg.3.json" %>%
    readLines() %>%
    as_vegaspec()

  expect_identical(vw_to_vega(spec_mtcars), spec_mtcars_vega)
  expect_identical(vw_to_vega(spec_mtcars_vega), spec_mtcars_vega)

})
