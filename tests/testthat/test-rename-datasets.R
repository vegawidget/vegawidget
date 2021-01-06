# create a named dataset for mtcars
spec_mtcars_ds <- spec_mtcars
spec_mtcars_ds$datasets <- list(foo = spec_mtcars$data$values)
spec_mtcars_ds$data$values = NULL
spec_mtcars_ds$data$name <- "foo"

spec_mtcars_ds_ref <- spec_mtcars_ds
names(spec_mtcars_ds_ref$datasets) <- "data_001"
spec_mtcars_ds_ref$data$name <- "data_001"

test_that("spec_mtcars is unchanged", {
  expect_identical(
    vw_rename_datasets(spec_mtcars),
    spec_mtcars
  )
})

test_that("named spec_mtcars works", {
  expect_identical(
    vw_rename_datasets(spec_mtcars_ds),
    spec_mtcars_ds_ref
  )
})
