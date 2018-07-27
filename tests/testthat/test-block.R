context("test-block.R")

test_that("vw_block_config yaml works", {
  expect_error(vw_block_config(license = "foo"), msg = "license not legal")
  expect_identical(
    vw_block_config(),
    "license: mit\nheight: 500\nscrolling: yes\nborder: yes\n"
  )
})

test_that("block index works", {

  index_ref <-
    readLines("../block/index.html") %>%
    paste(collapse = "\n")

  index <- vw_block_index(
    version = list(vega = "1.2.3", vega_lite = "4.5.6", vega_embed = "7.8.9"),
    embed = list(defaultStyle = TRUE, renderer = "canvas")
  )
  expect_identical(index, index_ref)

})
