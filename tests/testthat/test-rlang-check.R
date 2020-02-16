
# The purpose of these tests is to look for deprecation warnings
# from the rlang functions we use.

# If we had perfect test coverage, this would not be needed.

library("rlang")

test_that("rlang functions work and are silent", {

  # Trusting this is OK with the tidyverse team, if/when this
  # causes a revdep error, we commit to fix quickly.

  expect_silent(
    expect_identical(NULL %||% 4, 4)
  )

  expect_silent(enquo())
  expect_silent(eval_tidy(quote(paste("apple", "kiwi"))))

  expect_silent(has_name(mtcars, "mpg"))

  expect_silent(is_string("foo"))
  expect_silent(is_null(NULL))
  expect_silent(is_scalar_logical(TRUE))

})
