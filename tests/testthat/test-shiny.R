context("test-shiny.R")

library(shinytest)

test_that("binding ui to signal and listening works", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()
  #skip_on_travis()
  # for now, the test does not work on my (Ian's) MacBook,
  # so I cannot update, so tests are destined to fail

  appdir <- system.file(package = "vegawidget", "test-apps/signal")
  expect_pass(testApp(appdir, compareImages = FALSE))
})
