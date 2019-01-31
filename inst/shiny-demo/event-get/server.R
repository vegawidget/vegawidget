library("shiny")
library("tibble")
library("vegawidget")

spec_new <- spec_mtcars

server <- function(input, output) {

  ## reactives

  # the event returns the backing-data as a list
  rct_list_click <-
    vw_shiny_get_event("chart", event = "click", body_value = "datum")

  ## observers

  ## outputs

  # use a sample-spec that comes with the package
  output$chart <- renderVegawidget(spec_mtcars)

  # render as a data-frame
  output$event_out <- renderPrint({
    as_tibble(rct_list_click())
  })

}


