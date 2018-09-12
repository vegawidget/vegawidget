# This is an example shiny application that dynamically .  The app adds a click listener that prints the value of the data point.
# It also binds a slider UI element to the signal, which is used in the spec
# to filter the points.

library(shiny)
library(vegawidget)
library(dplyr)


gapminder <- gapminder::gapminder


ui <- shiny::fluidPage(
  shiny::titlePanel("gapminder example"),
  vegawidgetOutput("chart"),
  shiny::sliderInput("slider", "year",
                     min = 1952, max = 2007, step = 5,
                     value = 1952, sep = "", animate = TRUE)
)


# Define server logic
server <- function(input, output) {

  spec <- list(
    `$schema` = vega_schema(),
    width = 400,
    height = 400,
    description = "Global development over time",
    data = list(name = "source"),
    mark = "point",
    encoding = list(
      x = list(field = "gdpPercap",
               type = "quantitative",
               scale = list(type = "log", domain = range(gapminder$gdpPercap))),
      y = list(field = "lifeExp",
               type = "quantitative",
               scale = list(zero = FALSE, domain = range(gapminder$lifeExp))),
      color = list(field = "continent",
                   type = "nominal")
    )
  )

  # initial load of data to the spec, for the default value of year
  output$chart <- renderVegawidget({
    vegawidget(spec) %>%
      vw_load_data("source", dplyr::filter(gapminder, year == min(year)))
  })

  observe({
    year_f <- input$slider
    changeset <- gapminder %>%
      dplyr::filter(year == !!year_f)
    vw_change_data("chart", "source", changeset)
  })

}

# Run the application
shiny::shinyApp(ui = ui, server = server)

