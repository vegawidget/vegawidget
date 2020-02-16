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

test_that("combine function works", {

  signals_unique <-
    list(
      list(name = "foo", value = 0),
      list(name = "bar", value = 1)
    )

  signals_dup <- c(signals_unique, signals_unique)

  expect_identical(combine_signals(signals_unique), signals_unique)
  expect_identical(combine_signals(signals_dup), signals_unique)
})
