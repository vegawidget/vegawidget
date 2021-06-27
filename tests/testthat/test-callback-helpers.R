library("withr")

test_that("vw_fetch() works", {
  expect_snapshot(
    vw_fetch("https://vega.github.io/vega-datasets/data/anscombe.json")
  )
})

test_that("vw_load() works", {

  tmpfile <- local_tempfile()
  writeLines("foobar", tmpfile)

  expect_snapshot(
    vw_load(tmpfile)
  )
})
