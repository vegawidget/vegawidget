#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(vegawidget)

data_values <-
  list(
    list(a = "A", b = 28),
    list(a = "A", b = 27),
    list(a = "B", b = 55),
    list(a = "C", b = 43),
    list(a = "D", b = 91),
    list(a = "E", b = 81),
    list(a = "F", b = 53),
    list(a = "G", b = 19),
    list(a = "H", b = 87),
    list(a = "I", b = 52)
  )

spec <-
  list(
    `$schema` = "https://vega.github.io/schema/vega-lite/v2.json",
    description = "A simple bar chart with embedded data.",
    data = list(values = data_values),
    mark = "point",
    selection = list(brush = list(type = "interval")),
    encoding = list(
      x = list(field = "a", type = "ordinal"),
      y = list(field = "b", type = "quantitative")
    )
  )

ui <- shiny::fluidPage(

  shiny::titlePanel("vegawidget event example"),

  shiny::fluidRow(
    shiny::column(8, vegawidgetOutput("chart")),
    shiny::column(4, shiny::verbatimTextOutput("cl"))
  )
)



# Define server logic
server <- function(input, output) {

  output$chart <- renderVegawidget({
    vegawidget(spec)
  })

  output$cl <- shiny::renderPrint({
    input$chart_clicked
  })

}

# Run the application
shiny::shinyApp(ui = ui, server = server)

