# This is an example shiny application that dynamically animates the gapminder
# dataset.

library("shiny")
library("vegawidget")
library("dplyr")
library("gapminder")

# in this spec, we define the name of a dataset, but do not load it
spec <- list(
  `$schema` = vega_schema(),
  width = 400,
  height = 400,
  description = "Global development over time",
  data = list(name = "source"),
  mark = "point",
  encoding = list(
    x = list(
      field = "gdpPercap",
      type = "quantitative",
      scale = list(
        type = "log",
        domain = range(gapminder$gdpPercap)
      )
    ),
    y = list(
      field = "lifeExp",
      type = "quantitative",
      scale = list(
        zero = FALSE,
        domain = range(gapminder$lifeExp))
    ),
    color = list(field = "continent", type = "nominal")
  )
)

ui <- shiny::fluidPage(
  shiny::titlePanel("gapminder example"),
  vegawidgetOutput("chart"),
  shiny::sliderInput(
    "slider",
    label = "year",
    min = 1952,
    max = 2007,
    step = 5,
    value = 1952,
    sep = "",
    animate = TRUE
  )
)

# Define server logic
server <- function(input, output) {

  # reactives
  data_filtered <- reactive({
    gapminder %>% dplyr::filter(year == input$slider)
  })

  # observers
  observe({
    vw_change_data("chart", "source", data_filtered())
  })

  # outputs
  output$chart <- renderVegawidget({
    vegawidget(spec)
  })

}

# Run the application
shiny::shinyApp(ui = ui, server = server)

