# This is an example shiny application that uses a vega schema with a signal
# defined.  The app adds a click listener that prints the value of the data point.
# It also binds a slider UI element to the signal, which is used in the spec
# to filter the points.

library(shiny)
library(vegawidget)
library(magrittr)


spec <- jsonlite::fromJSON("example_vega_schema.json")

ui <- shiny::fluidPage(

  shiny::titlePanel("vegawidget event example"),
  shiny::fluidRow(shiny::sliderInput("slider", "Cylinders", min = 4, max = 6, step = 1, value = 6)),
  shiny::fluidRow(
    shiny::column(8, vegawidgetOutput("chart")),
    shiny::column(4, shiny::verbatimTextOutput("cl"))
  )
)


# Define server logic
server <- function(input, output) {

  output$chart <- renderVegawidget({
    vegawidget(spec) %>%
      vw_add_event_listener("click")
  })


  output$cl <- shiny::renderPrint({
    input$chart_click
  })

  vw_bind_ui("chart", "slider", "cyl")

}

# Run the application
shiny::shinyApp(ui = ui, server = server)

