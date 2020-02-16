test_that("signal-predicate works", {

  expect_signal <- function(x) {
    expect_true(is_signal(x))
  }

  expect_not_signal <- function(x) {
    expect_false(is_signal(x))
  }

  expect_signal(list(name = "foo", value = 0))

  expect_not_signal(list(name = "foo", value = 0, bar = "none"))
  expect_not_signal(list(name = c("foo", "bar"), value = 0))
  expect_not_signal(3)

})

test_that("equality function works", {


  expect_equal_signal <- function(x, y) {
    expect_true(equivalence_signal(x, y))
  }

  expect_not_equal_signal <- function(x, y) {
    expect_false(equivalence_signal(x, y))
  }

  expect_equal_signal(
    list(name = "foo", value = 1),
    list(name = "foo", value = 1)
  )

  expect_equal_signal(
    list(name = "foo", value = 1),
    list(name = "foo", value = 2)
  )

  expect_not_equal_signal(
    list(name = "foo", value = 1),
    list(name = "bar", value = 1)
  )

})
