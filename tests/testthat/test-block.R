context("test-block.R")

test_that("block yaml works", {
  expect_error(block_yaml(license = "foo"), msg = "license not legal")
  expect_identical(
    block_yaml(),
    "license: mit\nheight: 500\nscrolling: yes\nborder: yes\n"
  )
})

test_that("block index works", {

  index_ref <-
    readLines("../block/index.html")
  index <- block_index(
    spec = spec_mtcars,
    version = vega_versions(major = TRUE)
  )

  expect_identical(index, index_ref)

})
