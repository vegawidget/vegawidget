test_that("vw_to_vega works", {

  spec_mtcars_vega <- vw_to_vega(spec_mtcars)

  # use snapshot test
  expect_snapshot(vw_as_json(vw_to_vega(spec_mtcars_vega)))

  # expect no-op
  expect_identical(vw_to_vega(spec_mtcars_vega), spec_mtcars_vega)

})
