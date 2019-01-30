context("test-to-image.R")

spec_mtcars_vega <-
  "../spec/spec_mtcars.vg.3.json" %>%
  readLines() %>%
  as_vegaspec()

expected_svg <- readr::read_file("../reference/mtcars.svg")

# function to harmonize whitespace
ws <- function(x) {
  x <- trimws(x)
  x <- gsub("\r\n", "\n", x)

  x
}

has_node <- unname(nchar(Sys.which("node")) > 0L)

# Test SVG
test_that("vw_to_svg works with vega spec", {

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  svg_res <- vw_to_svg(spec_mtcars_vega)
  expect_identical(ws(svg_res), ws(expected_svg))

})

test_that("vw_to_svg works with vega-lite spec", {

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  svg_res <- vw_to_svg(spec_mtcars)
  expect_identical(ws(svg_res), ws(expected_svg))

})


