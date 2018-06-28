context("test-block.R")

test_that("block yaml works", {
  expect_error(block_yaml(license = "foo"), msg = "license not legal")
  expect_identical(
    block_yaml(),
    "license: mit\nheight: 500\nscrolling: yes\nborder: yes\n"
  )
})
