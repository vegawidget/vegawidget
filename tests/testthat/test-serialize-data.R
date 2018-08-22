context("test-serialize-data.R")

dttm <- as.POSIXct("2012-03-04 05:06:07", tz = "UTC")
attr(dttm, "tzone") <- "America/New_York"

str_dttm_local <- "2012-03-04 00:06:07.000"
str_dttm_iso   <- "2012-03-04T05:06:07.000Z"

date <- as.Date("2012-03-04")

str_date_iso <- "2012-03-04"
str_date_local <- "2012/03/04"

df_ref <- data.frame(dttm = dttm, date = date)

test_that("mtcars is unchanged", {
  expect_identical(vw_serialize_data(mtcars), mtcars)
})

test_that("single-values serialize correctly", {
  expect_identical(
    vw_serialize_data(df_ref, iso_dttm = TRUE, iso_date = TRUE),
    data.frame(
      dttm = str_dttm_iso,
      date = str_date_iso,
      stringsAsFactors = FALSE
    )
  )

  expect_identical(
    vw_serialize_data(df_ref, iso_dttm = FALSE, iso_date = FALSE),
    data.frame(
      dttm = str_dttm_local,
      date = str_date_local,
      stringsAsFactors = FALSE
    )
  )

  expect_identical(
    vw_serialize_data(df_ref, iso_dttm = TRUE, iso_date = FALSE),
    data.frame(
      dttm = str_dttm_iso,
      date = str_date_local,
      stringsAsFactors = FALSE
    )
  )

})

test_that("multiple-values serialize correctly", {
  mult <- data.frame(
    dttm = dttm + seq(0, 1),
    date = date + seq(0, 1)
  )

  str_mult <- data.frame(
    dttm = c("2012-03-04 00:06:07.000", "2012-03-04 00:06:08.000"),
    date = c("2012-03-04", "2012-03-05"),
    stringsAsFactors = FALSE
  )

  expect_identical(vw_serialize_data(mult), str_mult)
})
