# This is an example shiny application that uses a vega schema with a signal
# defined.  The app adds a click listener that prints the value of the data point.
# It also binds a slider UI element to the signal, which is used in the spec
# to filter the points.

library("shiny")
library("vegawidget")

spec <-
  jsonlite::fromJSON("example_vega_schema.json") %>%
  as_vegaspec()

ui <- shiny::fluidPage(

  shiny::titlePanel("vegawidget signal example"),
  shiny::fluidRow(
    shiny::sliderInput(
      "slider",
      label = "Cylinders",
      min = 4,
      max = 8,
      step = 2,
      value = 4
    )
  ),
  shiny::fluidRow(vegawidgetOutput("chart")),
  shiny::fluidRow(shiny::verbatimTextOutput("cl"))

)

# Define server logic
server <- function(input, output) {

  # reactives
  rct_cyl <-
    vw_shiny_get_signal("chart", name = "cyl", body_value = "return value;")

  # observers
  vw_shiny_set_signal("chart", name = "cyl", value = input$slider)

  # outputs
  output$chart <- renderVegawidget(spec)

  output$cl <- renderPrint(rct_cyl())
}

# Run the application
shiny::shinyApp(ui = ui, server = server)

