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

  expect_message(
    expect_identical(combine_signals(signals_dup), signals_unique),
    "foo, bar"
  )

})

test_that("pluck_all works", {

  list_00 <-
    list(
      a = 0,
      b = 1
    )

  list_01 <-
    list(
      a = list(b = "one"),
      b = c(letters[1:2]),
      c = list(a = list(b = "two")),
      d = list(g = list(b = "two")),
      e = list(f = list(a = list(b = "three")))
    )

  expect_identical(
    pluck_all(list_00, "b"),
    list(1)
  )

  expect_identical(
    pluck_all(list_01, "b"),
    list(c("a", "b"), "one", "two", "two", "three")
  )

  expect_identical(
    pluck_all(list_01, "b", .p = rlang::is_scalar_atomic),
    list("one", "two", "two", "three")
  )

  expect_identical(
    pluck_all(list_01, "b", .c = unique),
    list(c("a", "b"), "one", "two", "three")
  )

  expect_identical(
    pluck_all(list_01, "b", .p = rlang::is_scalar_atomic, .c = unique),
    list("one", "two", "three")
  )

  expect_identical(
    pluck_all(list_01, "a", .c = unique),
    list(list(b = "one"), list(b = "two"), list(b = "three"))
  )

})
