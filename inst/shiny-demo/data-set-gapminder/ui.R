library("shiny")
library("vegawidget")

ui_slider_year <-
  sliderInput(
    "slider",
    label = "year",
    min = 1952,
    max = 2007,
    step = 5,
    value = 1952,
    sep = "",
    animate = TRUE
  )

ui <- fluidPage(
  titlePanel("Vegawidget: Gapminder example"),
  sidebarLayout(
    sidebarPanel(
      ui_slider_year
    ),
    mainPanel(
      vegawidgetOutput("chart")
    )
  )
)
