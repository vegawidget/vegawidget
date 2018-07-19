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
    list(a = "A", b = 28, c = 3),
    list(a = "B", b = 55, c = 5),
    list(a = "C", b = 43, c = 6),
    list(a = "D", b = 91, c = 7),
    list(a = "E", b = 81, c = 8),
    list(a = "F", b = 53, c = 9),
    list(a = "G", b = 19, c = 10),
    list(a = "H", b = 87, c = 11),
    list(a = "I", b = 52, c = 12)
  )

spec <-
  list(
    `$schema` = "https://vega.github.io/schema/vega-lite/v2.json",
    description = "A simple bar chart with embedded data.",
    data = list(values = data_values),
    mark = "bar",
    selection = list(brush = list(type = "interval"),
                     click = list(type = "single")),
    encoding = list(
      x = list(field = "a", type = "ordinal"),
      y = list(field = "b", type = "quantitative")
    )
  )


vegawidget_addEventListener <- function(id, event, handler) {

  session <- shiny::getDefaultReactiveDomain()

  # prepair a message using the function arguments
  message <- list(id = id, event = event, handler = handler)
  print(class(message$handler))

  # send a custom message to JavaScript
  session$sendCustomMessage("addEventListener", message)

}


addShinyEventListener <- function(x, event){
  htmlwidgets::onRender(x, "function(el, x, data) {this.addShinyEventListener(data)}", event)
}

ui <- shiny::fluidPage(

  shiny::titlePanel("vegawidget event example"),

  shiny::fluidRow(
    shiny::column(8, vegawidgetOutput("chart")),
    shiny::column(4, shiny::verbatimTextOutput("cl"))
  )
)

library(magrittr)

# Define server logic
server <- function(input, output) {

  output$chart <- renderVegawidget({
    vegawidget(spec) %>% addShinyEventListener("click")
  })


  # shiny::observe({
  #   shiny::invalidateLater(5000)
  #   vegawidget_addEventListener("chart", event = "click",
  #                          handler = htmlwidgets::JS('function(event, item) {
  #                            console.log(item);
  #                            if (item !== null && item !== undefined && item.datum !== undefined){
  #                              Shiny.onInputChange(el.id + "_click",item.datum);
  #                            } else {
  #                              Shiny.onInputChange(el.id + "_click",null);
  #                            }
  #                          }'))}
  # )

  output$cl <- shiny::renderPrint({
    input$chart_click
  })

}

# Run the application
shiny::shinyApp(ui = ui, server = server)

