library("withr")
library("glue")

has_node <- unname(nchar(Sys.which("node")) > 0L)

# note https://www.svgviewer.dev/ is a useful place to copy-paste SVG strings

spec_wx <- as_vegaspec(
'{
  "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "data": {"url": "seattle-weather.csv"},
  "mark": "bar",
  "encoding": {
    "x": {"timeUnit": "utcmonth", "field": "date"},
    "y": {"aggregate": "mean", "field": "precipitation"}
  }
}'
)

base_url <- "https://vega.github.io/vega-datasets/data"

# Test SVG
test_that("vw_to_svg works with vega spec", {

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  expect_snapshot(
    cat(spec_mtcars %>% vw_to_vega() %>% vw_to_svg())
  )

})

test_that("vw_to_svg works with vega-lite spec", {

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  expect_snapshot(
    cat(vw_to_svg_new(spec_mtcars))
  )

})

test_that("vw_to_svg works with url data", {

  expect_snapshot(
    cat(vw_to_svg_new(spec_wx, base_url = base_url))
  )

})

test_that("vw_to_svg works with local data", {

  tempdir <- local_tempdir()

  download.file(
    glue("{base_url}/seattle-weather.csv"),
    destfile = glue("{tempdir}/seattle-weather.csv"),
    quiet = TRUE
  )

  expect_snapshot(
    cat(vw_to_svg_new(spec_wx, base_url = tempdir))
  )

})
