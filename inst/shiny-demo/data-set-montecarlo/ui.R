library("shiny")
library("vegawidget")

ui_slider_n <-
  shiny::sliderInput(
    "n_points",
    label = "Number of points",
    min = 1,
    value = 100,
    max = 5000,
    step = 1,
    sep = "",
    animate = TRUE
  )

ui <- fluidPage(
  titlePanel("Vegawidget: Monte-Carlo simulation of pi"),
  sidebarLayout(
    sidebarPanel(
      ui_slider_n
    ),
    mainPanel(
      vegawidgetOutput("chart")
    )
  )
)
