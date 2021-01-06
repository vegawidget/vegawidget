test_that("validation works", {

  # renderer
  expect_error(vega_embed(renderer = "foo"))

  # actions
  expect_error(vega_embed(actions = list(TRUE, TRUE)), "named")
  expect_error(vega_embed(actions = list(source = TRUE, FALSE)), "legal name")
  expect_error(vega_embed(actions = list(foo = TRUE)), "legal name")

  # actions$export
  expect_error(vega_embed(actions = list(export = list(TRUE, TRUE))), "named")
  expect_error(vega_embed(actions = list(export = list(foo = TRUE))), "legal name")

})

test_that("constructor works", {

  test_embed_default <- vega_embed()
  test_embed <- vega_embed(renderer = "svg", actions = list(source = FALSE))

  expect_identical(test_embed_default$renderer, "canvas")
  expect_null(test_embed_default$actions)

  expect_identical(test_embed$renderer, "svg")
  expect_identical(test_embed$actions, list(source = FALSE))

  # test export
  test_embed_export <-
    vega_embed(
      renderer = "svg",
      actions = list(export = list(svg = TRUE, png = FALSE))
    )

  expect_identical(
    test_embed_export$actions$export,
    list(svg = TRUE, png = FALSE)
  )

})

