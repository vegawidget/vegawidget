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

  svg_res <- spec_mtcars %>% vw_to_vega() %>% vw_to_svg()
  expect_snapshot(svg_res)

})

test_that("vw_to_svg works with vega-lite spec", {

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  svg_res <- vw_to_svg(spec_mtcars)
  expect_snapshot(svg_res)

})


