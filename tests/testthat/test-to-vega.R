context("test-to-vega.R")

library("magrittr")

has_node <- unname(nchar(Sys.which("node")) > 0L)

test_that("vw_to_vega works", {

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  spec_mtcars_vega <-
    "../spec/spec_mtcars.vg.5.json" %>%
    readLines() %>%
    as_vegaspec()

  expect_identical(vw_to_vega(spec_mtcars), spec_mtcars_vega)
  expect_identical(vw_to_vega(spec_mtcars_vega), spec_mtcars_vega)

})
