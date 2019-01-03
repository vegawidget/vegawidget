context("test-handlers")

test_that("vw_handler_body() works", {

  # retrieve a handler from the library
  expect_match(vw_handler_body("value", "signal")$text, "return value;$")

  # supply code for the body
  expect_match(vw_handler_body("return value;", "signal")$text, "^return value;$")

  # supply "nonsense"
  expect_warning(vw_handler_body("_value", "signal"), "handler_body")
})

test_that("vw_handler_signal() works", {

  handler_signal <- vw_handler_signal("value")

  # call empty, cats signal handlers in library
  expect_output(vw_handler_signal(), "^arguments: name, value")

  # returns a vw_handler
  expect_is(handler_signal, "vw_handler")

  # sending a handler is a no-op
  expect_identical(vw_handler_signal(handler_signal), handler_signal)

})

test_that("vw_handler_event() works", {

  handler_event <- vw_handler_event("datum")

  # call empty, cats event handlers in library
  expect_output(vw_handler_event(), "^arguments: event, item")

  # returns a vw_handler
  expect_is(handler_event, "vw_handler")

  # sending a handler is a no-op
  expect_identical(vw_handler_event(handler_event), handler_event)

})

test_that("vw_handler_add_effect() works", {

  handler <-
    vw_handler_signal("value") %>%
    vw_handler_add_effect("console")

  # call empty, cats effect handlers in library
  expect_output(vw_handler_add_effect(), "^arguments: x")

  # returns a vw_handler
  expect_is(handler, "vw_handler")

  # adds the effect
  expect_match(handler$body_effect, "console.log\\(x\\);$")
})

test_that("vw_handler_body_compose() works", {

  handler_signal <-vw_handler_signal("value")

  handler_signal_effect <-
    handler_signal %>%
    vw_handler_add_effect("console")

  expect_identical(
    vw_handler_body_compose(handler_signal, n_indent = 0L),
    handler_signal$body_value$text %>% as.character() %>% JS()
  )

  expect_match(
    vw_handler_body_compose(handler_signal_effect, n_indent = 0L),
    "^\\(function \\(x\\)"
  )
})

test_that("vw_handler_compose() works", {

  handler_signal <-vw_handler_signal("value")

  handler_signal_effect <-
    handler_signal %>%
    vw_handler_add_effect("console")

  expect_match(
    vw_handler_compose(handler_signal_effect),
    "^function \\(name, value\\)"
  )

  expect_warning(
    handler_signal %>% vw_handler_add_effect("element_text"),
    "params not set: selector"
  )
})

test_that("vw_add_event_handler() works", {

  vw <-
    vegawidget(spec_mtcars) %>%
    vw_add_event_listener("click", handler_body = "datum")

  expect_match(vw$jsHooks[[1]][[1]]$code, "^function\\(el, x\\)")
})


