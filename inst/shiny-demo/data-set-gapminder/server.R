library("shiny")
library("dplyr")
library("gapminder")
library("vegawidget")

# in this spec, we define the name of a dataset, but do not load it
spec <-
  list(
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
        axis = list(title = "GDP per-capita (USD)"),
        scale = list(
          type = "log",
          domain = range(gapminder$gdpPercap)
        )
      ),
      y = list(
        field = "lifeExp",
        type = "quantitative",
        axis = list(title = "life expectency (years)"),
        scale = list(
          zero = FALSE,
          domain = range(gapminder$lifeExp)
        )
      ),
      color = list(field = "continent", type = "nominal"),
      size = list(
        field = "pop",
        type = "quantitative",
        legend = list(title = "population"),
        scale = list(domain = range(gapminder$pop))
      ),
      tooltip = list(
        list(field = "year", type = "quantitative"),
        list(field = "country", type = "nominal"),
        list(field = "pop", type = "quantitative", format = ".3~s"),
        list(
          field = "gdpPercap",
          type = "quantitative",
          title = "GDP per-capita",
          format = ".3~s"
        ),
        list(
          field = "lifeExp",
          type = "quantitative",
          title = "life expectancy",
          format = ".1f"
        )
      )
    )
  ) %>%
  as_vegaspec()

server <- function(input, output) {

  # reactives
  #
  rct_data_year <- reactive({
    gapminder %>% dplyr::filter(year == input$slider)
  })

  # observers
  #
  vw_shiny_set_data("chart", name = "source", value = rct_data_year())

  # outputs
  #
  output$chart <- renderVegawidget(spec)

}
