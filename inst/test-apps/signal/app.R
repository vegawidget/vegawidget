# This is an example shiny application that uses a vega schema with a signal
# defined.  The app adds a click listener that prints the value of the data point.
# It also binds a slider UI element to the signal, which is used in the spec
# to filter the points.

library(shiny)
library(vegawidget)
library(magrittr)


spec <- jsonlite::fromJSON("example_vega_schema.json")

ui <- shiny::fluidPage(

  shiny::titlePanel("vegawidget signal example"),
  shiny::fluidRow(shiny::sliderInput("slider", "Cylinders", min = 4, max = 8, step = 2, value = 4)),
  shiny::fluidRow(vegawidgetOutput("chart")),
  shiny::fluidRow(shiny::verbatimTextOutput("cl"))

)


# Define server logic
server <- function(input, output) {

  # observers
  vw_shiny_set_signal(input$slider, output_id = "chart", name = "cyl")

  # outputs
  output$chart <- renderVegawidget({
    vegawidget(spec) %>%
      vw_add_signal_listener("cyl")
  })

  output$cl <- renderPrint({
    input$chart_cyl
  })

}

# Run the application
shiny::shinyApp(ui = ui, server = server)

