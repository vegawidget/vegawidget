test_that("throws errors", {
  expect_error(assert_packages(c("-foo-", "-bar-")), '"-foo-", "-bar-"')
})

test_that("works", {
  expect_true(assert_packages("base"))
})
