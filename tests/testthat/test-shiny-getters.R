test_that("get_unique_inputId() works", {

  expect_identical(get_unique_inputId("foo", c("bar", "baz")), "foo")
  expect_identical(get_unique_inputId("foo", c("foo", "bar", "baz")), "foo_1")

})
