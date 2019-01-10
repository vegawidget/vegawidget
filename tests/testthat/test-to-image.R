context("test-to-image.R")

spec_mtcars_vega <-
  "../spec/spec_mtcars.vg.3.json" %>%
  readLines() %>%
  as_vegaspec()

expected_svg <- readr::read_file("../reference/mtcars.svg")

# Test SVG
test_that("vw_to_svg works with vega spec", {

  skip_on_cran() # Need to have node installed

  svg_res <- vw_to_svg(spec_mtcars_vega)
  expect_identical(
    substr(svg_res, nchar(svg_res) - 40, nchar(svg_res)),
    substr(expected_svg, nchar(expected_svg) - 40, nchar(expected_svg))
  )
  # expect_identical(
  #   nchar(svg_res),
  #   nchar(expected_svg)
  # )
  #expect_identical(svg_res, expected_svg)

})

test_that("vw_to_svg works with vega-lite spec", {

  skip_on_cran() # Need to have node installed

  svg_res <- vw_to_svg(spec_mtcars)
  #expect_identical(svg_res, expected_svg)

})


