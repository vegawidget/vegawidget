library("shiny")
library("tibble")
library("vegawidget")

server <- function(input, output) {

  # reactives
  #

  # the event returns the backing-data as a list
  rct_list_click <-
    vw_shiny_get_event("chart", event = "click", body_value = "datum")

  # observers
  #

  # outputs
  #

  output$chart <- renderVegawidget(spec_mtcars)

  output$event_out <- renderPrint({
    as_data_frame(rct_list_click())
  })

}


