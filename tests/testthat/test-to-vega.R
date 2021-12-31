test_that("vw_to_vega works", {

  spec_mtcars_vega <- vw_to_vega(spec_mtcars)

  # use snapshot test
  expect_snapshot(vw_as_json(vw_to_vega(spec_mtcars)))

  # test VL4
  spec_mtcars4 <- with_schema(4, spec_mtcars)
  expect_snapshot(vw_as_json(vw_to_vega(spec_mtcars4)))

  # expect no-op
  expect_identical(vw_to_vega(spec_mtcars_vega), spec_mtcars_vega)

})
