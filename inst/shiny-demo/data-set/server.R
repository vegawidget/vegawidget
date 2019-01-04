library("shiny")
library("vegawidget")
library("tibble")


data_angle <- function(x) {

  theta = x * pi / 180.

  data_frame(x = cos(theta), y = sin(theta))
}

# Create vegaspec
#
spec_circle <-
  list(
    `$schema` = vega_schema(),
    width = 300,
    height = 300,
    data = list(
      values = list(x = 1, y = 0),
      name = "source"
    ),
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
  rct_data <- reactive(data_angle(input$angle))

  # observers
  #

  # whenever rct_data() changes, the chart will be updated
  vw_shiny_set_data("chart", name = "source", value = rct_data())

  # outputs
  #
  output$data_in <- renderPrint(rct_data())

  output$chart <- renderVegawidget(spec_circle)
}


