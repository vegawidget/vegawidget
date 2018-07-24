context("vega-embed")

test_that("validation works", {

  # renderer
  expect_error(vega_embed(renderer = "foo"))

  # actions
  expect_error(vega_embed(actions = list(TRUE, TRUE)), "must have length 1")
  expect_error(vega_embed(actions = list(source = TRUE, FALSE)), "must have length 1")
  expect_error(vega_embed(actions = list(foo = TRUE)), "illegal name")

})

test_that("constructor works", {

  test_embed_default <- vega_embed()
  test_embed <- vega_embed(renderer = "svg", actions = list(source = FALSE))

  expect_identical(test_embed_default$renderer, "canvas")
  expect_null(test_embed_default$actions)

  expect_identical(test_embed$renderer, "svg")
  expect_identical(test_embed$actions, list(source = FALSE))

})

