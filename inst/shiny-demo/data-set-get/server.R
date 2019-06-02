library("shiny")
library("vegawidget")
library("tibble")

# function to convert an angle to a dataset
data_angle <- function(x) {

  # degrees to radians
  theta = x * pi / 180.

  tibble(x = cos(theta), y = sin(theta))
}

# spec for the "circle"
spec_circle <-
  list(
    `$schema` = vega_schema(),
    width = 300,
    height = 300,
    data = list(name = "source"),
    mark = "point",
    encoding = list(
      x = list(
        field = "x",
        type = "quantitative",
        scale = list(domain = list(-1, 1))
      ),
      y = list(
        field = "y",
        type = "quantitative",
        scale = list(domain = list(-1, 1))
      )
    )
  ) %>%
  as_vegaspec()

server <- function(input, output) {

  # reactives
  #

  # returns dataset in response to the angle-input
  rct_data <- reactive(data_angle(input$angle))

  # returns the dataset in `"chart"` named `"source"`
  rct_data_out <- vw_shiny_get_data("chart", name = "source")

  # observers
  #

  # whenever rct_data() changes, the chart will be updated
  vw_shiny_set_data("chart", name = "source", value = rct_data())

  # outputs
  #

  # render the input data-frame
  output$data_in <- renderPrint(rct_data())

  # render the chart
  output$chart <- renderVegawidget(spec_circle)

  # render the input data-frame
  output$data_out <- renderPrint(rct_data_out() %>% as_tibble())

}


