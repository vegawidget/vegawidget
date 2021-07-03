library("withr")

# establish V8 session
ct <- V8::v8()
ct$source(system.file("bin", "vega_to_svg_v8.js", package = "vegawidget"))

test_that("vw_fetch() works", {

  expect_snapshot(
    vw_fetch("https://vega.github.io/vega-datasets/data/anscombe.json")
  )

  # check using V8
  # for syntax, see https://stackoverflow.com/a/49938734
  expect_snapshot(
    ct$eval("(async () => {console.log(await vwFetch('https://vega.github.io/vega-datasets/data/anscombe.json'))})()")
  )

})

test_that("vw_load() works", {

  tmpfile <- local_tempfile()

  # get rid of any backslashes (Windows)
  # we will have to keep that in mind in vw_to_svg()
  tmpfile <- gsub("\\\\", "/", tmpfile)

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

