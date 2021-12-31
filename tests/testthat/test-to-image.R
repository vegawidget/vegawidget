library("withr")
library("glue")

# note https://www.svgviewer.dev/ is a useful place to copy-paste SVG strings

spec_anscombe <- as_vegaspec(
'{
  "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "data": {"url": "anscombe.json"},
  "mark": "circle",
  "encoding": {
    "column": {"field": "Series"},
    "x": {
      "field": "X",
      "type": "quantitative",
      "scale": {"zero": false}
    },
    "y": {
      "field": "Y",
      "type": "quantitative",
      "scale": {"zero": false}
    },
    "opacity": {"value": 1}
  }
}'
)

# filtering the data:
#   - to cut down on the size of the SVG
#   - negative-signs on the axis are rendered differently in Windows
spec_wx <- as_vegaspec(
'{
  "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "data": {
    "url": "seattle-weather.csv"
  },
  "transform": [
    {"filter": "datum.temp_max < 5"},
    {"filter": "datum.temp_max > 0"},
    {"filter": "datum.temp_min > 0"}
  ],
  "mark": "circle",
  "encoding": {
    "x": {"field": "temp_max", "type": "quantitative"},
    "y": {"field": "temp_min", "type": "quantitative"}
  }
}'
)

base_url <- "https://vega.github.io/vega-datasets/data"

# Test SVG
test_that("vw_to_svg works with vega spec", {

  expect_snapshot(
    cat(spec_mtcars %>% vw_to_vega() %>% vw_to_svg())
  )

})

test_that("vw_to_svg works with vega-lite spec", {

  expect_snapshot(
    cat(vw_to_svg(spec_mtcars))
  )

  # test VL4
  spec_mtcars4 <- with_schema(4, spec_mtcars)
  expect_snapshot(
    cat(vw_to_svg(spec_mtcars4))
  )

})

test_that("vw_to_svg works with url data", {

  # json
  expect_snapshot(
    cat(vw_to_svg(spec_anscombe, base_url = base_url))
  )

  # csv
  expect_snapshot(
    cat(vw_to_svg(spec_wx, base_url = base_url))
  )

})

test_that("vw_to_svg works with local data", {

  tempdir <- local_tempdir()

  # json
  download.file(
    glue("{base_url}/anscombe.json"),
    destfile = glue("{tempdir}/anscombe.json"),
    quiet = TRUE
  )

  expect_snapshot(
    cat(vw_to_svg(spec_anscombe, base_url = tempdir))
  )

  # json
  download.file(
    glue("{base_url}/seattle-weather.csv"),
    destfile = glue("{tempdir}/seattle-weather.csv"),
    quiet = TRUE
  )

  expect_snapshot(
    cat(vw_to_svg(spec_wx, base_url = tempdir))
  )

})
