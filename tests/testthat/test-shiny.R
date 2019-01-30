context("test-shiny.R")

library(shinytest)

test_that("binding ui to signal and listening works", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()

  # I am having problems getting phantomJS to work right
  # on my windows machine
  skip_on_os("windows")

  appdir <- system.file(package = "vegawidget", "test-apps/signal")
  expect_pass(testApp(appdir, compareImages = FALSE))
})
