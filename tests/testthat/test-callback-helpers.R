library("withr")

# establish V8 session
ct <- V8::v8()
ct$source(system.file("bin", "vega_to_svg_v8.js", package = "vegawidget"))

test_that("vw_fetch() works", {
  expect_snapshot(
    vw_fetch("https://vega.github.io/vega-datasets/data/anscombe.json")
  )

  # check using V8
  expect_snapshot(
    ct$eval("(async () => {console.log(await vwFetch('https://vega.github.io/vega-datasets/data/anscombe.json'))})()")
  )

})

test_that("vw_load() works", {

  tmpfile <- local_tempfile()
  writeLines("foobar", tmpfile)

  expect_snapshot(
    vw_load(tmpfile)
  )

  # check using V8
  expect_snapshot(
    ct$eval(
      glue_js("(async () => {console.log(await vwLoad('${tmpfile}'))})()")
    )
  )
})

