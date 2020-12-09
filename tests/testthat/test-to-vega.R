has_node <- unname(nchar(Sys.which("node")) > 0L)

test_that("vw_to_vega works", {

  # Need to have node installed
  skip_on_cran()
  skip_if_not(has_node)

  spec_mtcars_vega <- vw_to_vega(spec_mtcars)

  # use snapshot test
  expect_snapshot(vw_as_json(vw_to_vega(spec_mtcars_vega)))

  # expect no-op
  expect_identical(vw_to_vega(spec_mtcars_vega), spec_mtcars_vega)

})
