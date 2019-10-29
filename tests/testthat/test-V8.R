library("V8")

ctx <- v8()

test_that("V8 (ES5) works", {
  ctx$eval("var foo = 123")
  expect_identical(ctx$get("foo"), 123L)
})

test_that("V8 (ES6) works", {
  ctx$eval("let bar = 123")
  expect_identical(ctx$get("bar"), 123L)
})
