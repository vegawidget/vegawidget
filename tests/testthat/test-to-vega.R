context("to-vega")

library("magrittr")

test_that("vw_to_vega works", {

  vw_ex_mtcars_vega <-
    "../spec/vw_ex_mtcars.vg.3.json" %>%
    readLines() %>%
    as_vegaspec()

  expect_identical(vw_to_vega(vw_ex_mtcars), vw_ex_mtcars_vega)
  expect_identical(vw_to_vega(vw_ex_mtcars_vega), vw_ex_mtcars_vega)

})
